# frozen_string_literal: true

class WelcomeMailerPreview < ActionMailer::Preview
  def new_signup_email
    member = Member.first
    request_uuid = "bff7be6b-cc25-4e01-aa4d-2e27ac878419"
    request_ip = "172.30.40.50"
    WelcomeMailer.with(member: member, request_uuid: request_uuid, request_ip: request_ip).new_signup_email
  end

  def thank_you_email
    member = Member.first
    WelcomeMailer.with(member: member).thank_you_email
  end
end
