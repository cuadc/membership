# frozen_string_literal: true

class GraduatingMailer < ApplicationMailer
  def check_email
    @member = params[:member]
    raise ArgumentError, 'not an Ordinary Member' if @member.mtype_id != 1
    to_addr = [@member.primary_email]
    to_addr << @member.secondary_email unless @member.secondary_email.nil?
    mail(to: to_addr.uniq, bcc: 'chtj2@srcf.net', from: 'bookkeeping@membership.cuadc.org',
      subject: 'CUADC Membership After Graduation')
  end
end
