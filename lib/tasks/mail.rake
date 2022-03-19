# frozen_string_literal: true

namespace :membership do
  namespace :mail do
    desc "Email producers and directors their show's membership report"
    task shows: :environment do
      shows = Membership::Camdram.client.get_society("cambridge-university-amateur-dramatic-club").shows
      show.each do |show|
        ShowsMailer.with(show_id: show.id).individual_email.deliver_now
      end
    end
  end
end
