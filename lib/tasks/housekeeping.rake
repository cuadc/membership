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

    desc "Synchronise the list of soc-adc-members subscribers"
    task sync_sympa: :environment do
      doy = Date.today.yday
      next if doy < 2 || doy > 364
      PaperTrail.request.whodunnit = 'Sympa Synchronisation Batch Job'
      ::Membership::SympaSync.sync_members(Member.all)
    end

    desc "Synchronise the lookup information of all ucam members"
    task sync_lookup: :environment do
      doy = Date.today.yday
      next if doy < 2 || doy > 364
      PaperTrail.request.whodunnit = 'Lookup Synchronisation Batch Job'
      ::Membership::LookupSync.sync_members(Member.where.not(crsid: nil))
    end

    desc "Synchronise the SMTP callout information of all ucam members"
    task sync_smtp_callout: :environment do
      doy = Date.today.yday
      next if doy < 2 || doy > 364
      PaperTrail.request.whodunnit = 'SMTP Callout Synchronisation Batch Job'
      ::Membership::SmtpSync.sync_members(Member.where.not(crsid: nil))
    end
  end
end
