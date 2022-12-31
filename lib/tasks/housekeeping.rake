# frozen_string_literal: true

namespace :membership do
  namespace :housekeeping do
    desc "Mark graduated Ordinary Members as Associate Members"
    task process_graduates: :environment do
      PaperTrail.request.whodunnit = 'Graduation Batch Job'
      grads = Member.graduating
      puts 'Unsubscribe the following addresses from the soc-adc-members list:'
      grads.each do |member|
        old_email = member.contact_email
        member.mtype_id = 2
        if member.save(validate: false)
          puts old_email if old_email
        end
      end
      grads.each do |m|
        unless m.changed?
          GraduatingMailer.with(member: m).confer_email.deliver_now
        end
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
      doy = Date.today.yday
      next if doy < 2 || doy > 364
      PaperTrail.request.whodunnit = 'Lookup Synchronisation Batch Job'
      Member.ordinary.where.not(crsid: nil).each do |m|
        result = Membership::Lookup.is_student?(m.crsid)
        if result.nil?
          puts "#{m.crsid} was not found in Lookup"
        elsif !result
          puts "#{m.crsid} is not a student"
          if m.graduation_year > Date.today.year
            m.graduation_year = Date.today.year
          end
          m.mtype_id = 2
          m.save!
        end
      end
      Member.associate.where.not(crsid: nil).each do |m|
        result = Membership::Lookup.is_student?(m.crsid)
        if result.nil?
          puts "#{m.crsid} was not found in Lookup" if m.graduation_year >= 2013
        elsif result
          puts "#{m.crsid} is a student"
          new_year = Date.today.month >= 8 ? Date.today.year + 1 : Date.today.year
          m.mtype_id = 1
          m.graduation_year = new_year
          m.save!
        end
      end
    end
  end
end
