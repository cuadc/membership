class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def ballot_list
    @members = Member.ordinary.not_expired
  end

  def import
    @members = Member.not_expired.not_legacy_email
    response.headers["Content-Type"] = "application/octet-stream"
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
    params.require(:member).permit(:camdram_id, :crsid, :last_name, :other_names, :primary_email, :secondary_email, :institution_id, :graduation_year, :type_id, :expiry)
  end
end
