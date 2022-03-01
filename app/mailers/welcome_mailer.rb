# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def thank_you_email
    @member = params[:member]
    mail(to: @member.primary_email, subject: 'CUADC Membership Signup')
  end
end
