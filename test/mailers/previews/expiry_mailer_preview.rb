# frozen_string_literal: true

class ExpiryMailerPreview < ActionMailer::Preview
  def reminder_email
    mem = Member.all.filter { |m| m.canned_expiry.present? }.first
    ExpiryMailer.with(member: mem).reminder_email
  end
end
