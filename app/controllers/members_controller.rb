class MembersController < ApplicationController
  def index
    @members = Member.includes(:mtype, :purchase_ingest_items).where.not(mtype_id: 999).order(:graduation_year)
  end

  def ballot_list
    @members = [
      Member.includes(:mtype, :purchase_ingest_items).ordinary.not_manual_expires.order(:graduation_year),
      Member.includes(:mtype, :purchase_ingest_items).ordinary.not_canned_expires.order(:graduation_year)
    ].reduce(&:+).sort_by(&:graduation_year)
  end

  def pending_signups
    @purchase_ingest_items = PurchaseIngestItem.needs_linking
    @members = Member.needs_linking
  end

  def link_signups
    item = PurchaseIngestItem.needs_linking.find(params.require(:item))
    member = Member.needs_linking.detect { |i| i.id.to_s == params.require(:member) }
    raise 'protected operation' if member.inhibited? && !current_user.sysop?
    memoized_date = item.purchased.dup
    ActiveRecord::Base.transaction do
      item.update!(member: member)
      member.update!(mtype_id: 1, expiry: nil) # Canned expiry
    end
    PurchaseIngestItem.find(item.id).update!(purchased: memoized_date) # Sigh, MySQL.
    WelcomeMailer.with(member: member).thank_you_email.deliver_now
    redirect_to pending_signups_members_path
  end

  def camdram_associations_needed
    @members = Member.where(mtype_id: 1, camdram_id: nil).where.not(created_at: nil).last(50)
  end

  def cards_needed
    @members = Member.where(mtype_id: 1, card_issued: nil).where.not(created_at: nil)
  end

  def issue_card
    member = Member.find(params[:id])
    raise 'protected operation' if member.inhibited? && !current_user.sysop?
    raise 'card already issued' if member.card_issued.present?
    member.update!(card_issued: Date.today)
    WelcomeMailer.with(member: member).card_awaiting_email.deliver_now
    redirect_to cards_needed_members_path
  end

  def import
    @members = Member.ordinary.not_legacy_email.not_manual_expires +
      Member.ordinary.not_legacy_email.not_canned_expires +
      Member.associate.not_legacy_email + Member.honorary.not_legacy_email
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
    raise 'protected operation' if @member.inhibited? && !current_user.sysop?
    if @member.update(member_params)
      redirect_to @member
    else
      render :edit
    end
  end

  def show
    @member = Member.find(params[:id])
    @audit = []
    @member.versions.each do |ver|
      @audit << {
        event: ver.event,
        time: ver.created_at,
        user: user_name_from_whodunnit(ver),
        changeset: ver.changeset
      }
    end
    @lookup_data = Membership::Lookup.about(@member.crsid)
  end

  def destroy
    @member = Member.find(params[:id])
    raise 'protected operation' unless current_user.sysop?
    @member.destroy
    redirect_to members_path
  end

  private

  def member_params
    params.require(:member).permit(:name, :camdram_id, :crsid, :primary_email, :secondary_email, :institution_id, :graduation_year, :mtype_id, :canned_expiry, :notes)
  end

  def user_name_from_whodunnit(ver)
    begin
      User.find(ver.whodunnit).name
    rescue
      ver.whodunnit
    end
  end
end
