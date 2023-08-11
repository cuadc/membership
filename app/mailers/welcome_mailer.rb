# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def card_awaiting_email
    @member = params[:member]
    return if @member.no_mail
    mail(to: @member.primary_email, subject: 'CUADC Membership Card')
  end

  def new_signup_notification_email
    @member = params[:member]
    to_addr = overridable_to('members@cuadc.org')
    mail(to: to_addr, reply_to: @member.both_emails, bcc: 'chtj2@srcf.net', subject: 'CUADC Membership Signup')
  end

  def new_mem_thank_you_email
    @member = params[:member]
    return if @member.no_mail
    mail(to: @member.primary_email, subject: 'CUADC Membership Signup')
  end

  def verification_email
    @token = params[:token]
    mail(to: @token.email, subject: 'CUADC Membership Email Verification')
  end
end
