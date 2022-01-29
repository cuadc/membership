class MembersController < ApplicationController
  def index
    @members = Member.includes(:type, :purchase_ingest_items).where.not(type_id: 999).order(:graduation_year)
  end

  def ballot_list
    @members = [
      Member.includes(:type, :purchase_ingest_items).ordinary.not_manual_expires.order(:graduation_year),
      Member.includes(:type, :purchase_ingest_items).ordinary.not_canned_expires.order(:graduation_year)
    ].reduce(&:+).sort_by(&:graduation_year)
  end

  def pending_signups
    @purchase_ingest_items = PurchaseIngestItem.needs_linking
    @members = Member.needs_linking
  end

  def link_signups
    item = PurchaseIngestItem.needs_linking.find(params.require(:item))
    member = Member.needs_linking.detect { |i| i.id.to_s == params.require(:member) }
    type_ord = Type.find_by(name: "Ordinary")
    ActiveRecord::Base.transaction do
      item.update!(member: member)
      member.update!(type: type_ord, expiry: nil) # Canned expiry
    end
    redirect_to pending_signups_members_path
  end

  def import
    @members = Member.not_expired.map { |i| i.not_legacy_email }.reduce(&:+)
    response.headers["Content-Disposition"] = "attachment"
  end

  def new
    @member = Member.new
  end

  def edit
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member
    else
      render :new
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to @member
    else
      render :edit
    end
  end

  def show
    @member = Member.find(params[:id])
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to members_path
  end

  private

  def member_params
    params.require(:member).permit(:name, :camdram_id, :crsid, :primary_email, :secondary_email, :institution_id, :graduation_year, :type_id, :canned_expiry)
  end
end
