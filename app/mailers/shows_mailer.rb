# frozen_string_literal: true

class ShowsMailer < ApplicationMailer
  def report_email
    @shows = Membership::Camdram.client.get_society("cambridge-university-amateur-dramatic-club").shows
    to_addr = params.try(:fetch, :to) || [
      'president@cuadc.org',
      'members@cuadc.org'
    ]
    mail(to: to_addr, bcc: 'chtj2@srcf.net', subject: 'CUADC Show Membership Report')
  end
end
