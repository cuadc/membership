# frozen_string_literal: true

class GraduatingMailer < ApplicationMailer
  def check_email
    @member = params[:member]
    raise ArgumentError, 'not an Ordinary Member' if @member.mtype_id != 1
    return unless @member.both_emails.length > 0
    mail(to: @member.both_emails, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership After Graduation')
  end

  def confer_email
    @member = params[:member]
    raise ArgumentError, 'not an Associate Member' if @member.mtype_id != 2
    return unless @member.contact_email
    mail(to: @member.contact_email, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Associate Membership')
  end
end
