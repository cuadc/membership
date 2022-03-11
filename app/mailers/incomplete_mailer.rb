# frozen_string_literal: true

class IncompleteMailer < ApplicationMailer
  def no_details_email
    @member = params[:member]
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    if @member.crsid.present?
      emails << crsid + "@cantab.net" unless emails.map { |s| s.ends_with?('@cantab.net') }.include?(true)
      emails << crsid + "@cantab.ac.uk" unless emails.map { |s| s.ends_with?('@cantab.ac.uk') }.include?(true)
    end
    emails.uniq!.reject! { |e| e.starts_with?('unknown-member-email-') && e.ends_with?('@cuadc.org') }
    mail(to: emails, subject: 'CUADC Membership Details')
  end

  def no_payment_email
    @member = params[:member]
    raise ArgumentError, 'member not awaiting payment' if @member.mtype_id != 999
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    mail(to: emails, subject: 'CUADC Membership Payment')
  end

  def no_signup_email
    mail(to: params[:email], subject: 'CUADC Membership Signup')
  end
end
