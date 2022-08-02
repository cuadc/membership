# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def card_awaiting_email
    @member = params[:member]
    return if @member.no_mail
    mail(to: @member.primary_email, subject: 'CUADC Membership Card')
  end

  def new_signup_email
    @member = params[:member]
    @request_uuid = params[:request_uuid]
    @request_ip = params[:request_ip]
    to_addr = overridable_to('members@cuadc.org')
    mail(to: to_addr, reply_to: @member.both_emails, bcc: 'chtj2@srcf.net', subject: 'CUADC Membership Signup')
  end

  def thank_you_email
    @member = params[:member]
    return if @member.no_mail
    mail(to: @member.primary_email, subject: 'CUADC Membership Signup')
  end
end
