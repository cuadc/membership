class MembersController < ApplicationController
  def index
    @members = Member.all
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
      byebug
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
    params.require(:member).permit(:camdram_id)
                           .permit(:crsid)
                           .permit(:last_name)
                           .permit(:other_names)
                           .permit(:primary_email)
                           .permit(:secondary_email)
                           .permit(:institution)
                           .permit(:graduation_year)
                           .permit(:type)
                           .permit(:expiry)
  end
end
