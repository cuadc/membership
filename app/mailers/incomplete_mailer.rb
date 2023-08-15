class IncompleteMailer < ApplicationMailer
  def no_details_email
    @member = params[:member]
    return if @member.no_mail
    emails = [@member.primary_email.downcase, @member.secondary_email.downcase]
    if @member.crsid.present?
      emails << crsid.downcase + "@cantab.net" unless emails.map { |s| s.ends_with?('@cantab.net') }.include?(true)
      emails << crsid.downcase + "@cantab.ac.uk" unless emails.map { |s| s.ends_with?('@cantab.ac.uk') }.include?(true)
    end
    emails.compact!.uniq!.reject! { |e| e.starts_with?('unknown-member-email-') && e.ends_with?('@cuadc.org') }
    mail(to: emails, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Details')
  end

  def no_payment_email
    @member = params[:member]
    raise ArgumentError, 'member not awaiting payment' if @member.mtype_id != 999
    return unless @member.both_emails.length > 0
    mail(to: @member.both_emails, from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Payment')
  end

  def no_signup_email
    mail(to: params[:email], from: 'bookkeeping@membership.cuadc.org', subject: 'CUADC Membership Signup')
  end
end
