class SignupController < ApplicationController
  skip_before_action :check_user!
  before_action do
    @institutions = Institution.where.not(id: [1, 34, 35])
  end

  def verify
    PaperTrail.request.whodunnit = 'Email Verification'
    ActiveRecord::Base.transaction do
      @token = EmailVerificationToken.find_by!(uuid: params[:uuid])
      @token.update!(verified: true)
      @tokens = @token.member.email_verification_tokens.where(verified: false)
      if @tokens.length == 0
        if @token.member.mtype_id == 998
          @token.member.update!(mtype_id: 999)
          WelcomeMailer.with(member: @token.member).new_signup_notification_email.deliver_now
        end
        if @token.member.mtype_id == 999
          redirect_to :pay
        end
      end
    end
  end

  def pay; end

  def new
    @member = Member.new
  end

  def create
    CurrentRequest.signup = true
    PaperTrail.request.whodunnit = 'Web Signup'
    @member = Member.new(member_params)

    # Check that the privacy policy was accepted by the user
    unless params[:privacy_policy][:accepted] == "1"
      @member.errors.add(:base, "You must accept the privacy policy")
      render :new and return
    end

    # Check that the institution is valid
    if @member.institution_id.present?
      unless @institutions.include?(@member.institution)
        @member.errors.add(:institution, "is invalid")
        render :new and return
      end
    end

    @member.mtype_id = 998
    ActiveRecord::Base.transaction do
      if @member.valid? && verify_recaptcha(model: @member) && @member.save
        primary_token = EmailVerificationToken.generate(@member.primary_email, @member.id)
        secondary_token = EmailVerificationToken.generate(@member.secondary_email, @member.id)
        WelcomeMailer.with(token: primary_token).verification_email.deliver_now
        WelcomeMailer.with(token: secondary_token).verification_email.deliver_now
        redirect_to :verify
      else
        render :new
      end
    end
  end

  private

  def member_params
    params.require(:member).permit(:name, :crsid, :primary_email, :secondary_email, :institution_id, :graduation_year)
  end
end
