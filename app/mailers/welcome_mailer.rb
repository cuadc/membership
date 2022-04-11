# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def new_signup_email
    @member = params[:member]
    @request_uuid = params[:request_uuid]
    to_addr = overridable_to('members@cuadc.org')
    reply_to_addr = [@member.primary_email]
    reply_to_addr << @member.secondary_email unless @member.secondary_email.nil?
    mail(to: to_addr, reply_to: reply_to_addr.uniq, bcc: 'chtj2@srcf.net', subject: 'CUADC Membership Signup')
  end

  def thank_you_email
    @member = params[:member]
    mail(to: @member.primary_email, subject: 'CUADC Membership Signup')
  end
end
