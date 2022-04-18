# frozen_string_literal: true

namespace :membership do
  namespace :housekeeping do

    desc "Generate member CRSids from primary email addresses"
    task generate_crsids: :environment do
      Member.where(crsid: nil).where("primary_email LIKE '%cam.ac.uk'").find_each do |member|
        parts = member.primary_email.split("@")
        begin
          if parts.length == 2 && parts[1] == "cam.ac.uk"
            member.crsid = parts[0].downcase
            member.save(validate: false)
          end
        rescue => e
          puts "Member #{member.id}: #{e}"
        end
      end
    end

    desc "Mark graduated Ordinary Members as Associate Members"
    task process_graduates: :environment do
      PaperTrail.request.whodunnit = 'Batch Job'
      Member.ordinary.where("graduation_year <= ?", Date.today.year).find_each do |member|
        member.mtype_id = 2
        member.save(validate: false)
      end
    end

    desc "Search for shows without contact details"
    task new_shows: :environment do
      show_ids = Membership::Camdram.client.get_society(1).shows.map(&:id)
      contact_ids = ShowContactDetails.pluck(:camdram_id).uniq
      new_show_ids = show_ids.reject { |id| contact_ids.include?(id) }
      puts "New show IDs: #{new_show_ids}" unless new_show_ids.empty?
    end
  end
end
