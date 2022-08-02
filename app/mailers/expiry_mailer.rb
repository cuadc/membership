# frozen_string_literal: true

class ExpiryMailer < ApplicationMailer
  def reminder_email
    @member = params[:member]
    raise ArgumentError, 'not an Ordinary Member' if @member.mtype_id != 1
    return unless @member.both_emails.length > 0
    mail(to: @member.both_emails, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Expiry')
  end
end
