class SignupController < ApplicationController
  skip_before_action :check_user!

  def pay; end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.type_id = 999
    if verify_recaptcha(model: @member) && @member.save
      redirect_to :pay
    else
      render :new
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :crsid, :primary_email, :secondary_email, :institution_id, :graduation_year)
  end
end
