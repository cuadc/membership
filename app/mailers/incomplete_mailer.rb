# frozen_string_literal: true

class IncompleteMailer < ApplicationMailer
  def no_details_email
    @member = params[:member]
    return if @member.no_mail
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    if @member.crsid.present?
      emails << crsid + "@cantab.net" unless emails.map { |s| s.ends_with?('@cantab.net') }.include?(true)
      emails << crsid + "@cantab.ac.uk" unless emails.map { |s| s.ends_with?('@cantab.ac.uk') }.include?(true)
    end
    emails.uniq!.reject! { |e| e.starts_with?('unknown-member-email-') && e.ends_with?('@cuadc.org') }
    mail(to: emails.uniq, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Details')
  end

  def no_payment_email
    @member = params[:member]
    raise ArgumentError, 'member not awaiting payment' if @member.mtype_id != 999
    return if @member.no_mail
    emails = [@member.primary_email]
    emails << @member.secondary_email if @member.secondary_email.present?
    mail(to: emails.uniq, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Payment')
  end

  def no_signup_email
    mail(to: params[:email], from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Signup')
  end
end
