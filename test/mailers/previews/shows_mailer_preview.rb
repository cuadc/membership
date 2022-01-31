# frozen_string_literal: true

class ShowsMailerPreview < ActionMailer::Preview
  def report_email
    ShowsMailer.report_email
  end
end
