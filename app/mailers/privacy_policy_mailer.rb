class PrivacyPolicyMailer < ApplicationMailer
  def policy_update_email
    @member = params[:member]
    email = @member.contact_email
    return if @member.no_mail || email.blank?
    return if email.starts_with?('unknown-member-email-') || email.ends_with?('@cuadc.org')
    mail(to: email, subject: 'CUADC Privacy Policy Update')
  end
end
