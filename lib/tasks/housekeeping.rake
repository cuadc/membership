# frozen_string_literal: true

namespace :membership do
  namespace :housekeeping do
    desc "Mark graduated Ordinary Members as Associate Members"
    task process_graduates: :environment do
      PaperTrail.request.whodunnit = 'Batch Job'
      Member.graduating.find_each do |member|
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

    desc "Find non-students via Lookup"
    task scan_lookup: :environment do
      Member.ordinary.each do |m|
        next unless m.crsid.present?
        result = Membership::Lookup.is_student?(m.crsid)
        if result.nil?
          puts "#{m.crsid} was not found in Lookup"
        elsif !result
          puts "#{m.crsid} is not a student"
        end
      end
    end
  end
end
