# frozen_string_literal: true

class ExpiryMailer < ApplicationMailer
  def reminder_email
    @member = params[:member]
    raise ArgumentError, 'not an Ordinary Member' if @member.mtype_id != 1
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    mail(to: emails.uniq, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Expiry')
  end
end
