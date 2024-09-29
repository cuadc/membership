class PrivacyPolicyMailerPreview < ActionMailer::Preview
  def policy_update_email
    mem = Member.first
    PrivacyPolicyMailer.with(member: mem).policy_update_email
  end
end
