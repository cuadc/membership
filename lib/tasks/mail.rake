# frozen_string_literal: true

namespace :membership do
  namespace :mail do
    desc "Email administrative staff a membership report overview for all upcoming shows"
    task staff: :environment do
      ShowsMailer.overview_email.deliver_now
    end

    desc "Email producers and directors their show's membership report"
    task shows: :environment do
      shows = Membership::Camdram.client.get_society(1).shows
      shows.each do |show|
        ShowsMailer.with(show_id: show.id).individual_email.deliver_now
      end
    end
  end
end
