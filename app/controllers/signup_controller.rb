class SignupController < ApplicationController
  skip_before_action :check_user!

  def pay; end

  def new
    @member = Member.new
  end

  def create
    PaperTrail.request.whodunnit = 'Web Signup'
    @member = Member.new(member_params)
    @member.mtype_id = 999
    @member.validate_secondary_email = true
    if @member.valid? && verify_recaptcha(model: @member) && @member.save
      WelcomeMailer.with(member: @member, request_uuid: request.uuid, request_ip: request.ip).new_signup_email.deliver_now
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
