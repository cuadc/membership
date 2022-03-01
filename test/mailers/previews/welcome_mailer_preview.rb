# frozen_string_literal: true

class WelcomeMailerPreview < ActionMailer::Preview
  def thank_you_email
    member = Member.first
    WelcomeMailer.with(member: member).thank_you_email
  end
end
