# frozen_string_literal: true

class ExpiryMailer < ApplicationMailer
  def reminder_email
    @member = params[:member]
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    mail(to: emails, subject: 'CUADC Membership Expiry')
  end
end