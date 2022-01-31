# frozen_string_literal: true

class ShowsMailer < ApplicationMailer
  def report_email
    @shows = Membership::Camdram.client.get_society("cambridge-university-amateur-dramatic-club").shows
    mail(to: params.try(:fetch, :to) || User.pluck(:email), subject: 'CUADC Show Membership Report')
  end
end
