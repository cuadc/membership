# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def new_signup_email
    @member = params[:member]
    @request_uuid = params[:request_uuid]
    mail(to: 'chtj2@srcf.net', subject: 'CUADC Membership Signup')
  end

  def thank_you_email
    @member = params[:member]
    mail(to: @member.primary_email, subject: 'CUADC Membership Signup')
  end
end
