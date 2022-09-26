class SignupController < ApplicationController
  skip_before_action :check_user!

  def verify
    PaperTrail.request.whodunnit = 'Email Verification'
    if params[:uuid]
      ActiveRecord::Base.transaction do
        @token = EmailVerificationToken.find_by(uuid: params[:uuid])
        return unless @token
        @token.update!(verified: true)
        @tokens = @token.member.email_verification_tokens.where(verified: false)
        if @tokens.length == 0
          mail_already_sent = @token.member.mtype_id == 999
          @token.member.update!(mtype_id: 999)
          unless mail_already_sent
            WelcomeMailer.with(member: @token.member).new_signup_notification_email.deliver_now
          end
          redirect_to :pay
        end
      end
    end
  end

  def pay; end

  def new
    @member = Member.new
    @institutions = Institution.where.not(id: [1, 34, 35])
  end

  def create
    PaperTrail.request.whodunnit = 'Web Signup'
    @member = Member.new(member_params)
    if @member.institution_id.present?
      @institutions = Institution.where.not(id: [1, 34, 35])
      unless @institutions.include?(@member.institution)
        @member.errors.add(:institution, "is invalid")
        render :new and return
      end
    end
    @member.mtype_id = 998
    @member.validate_secondary_email = true
    @member.validate_crsid = true
    @member.validate_cam_email = true
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
