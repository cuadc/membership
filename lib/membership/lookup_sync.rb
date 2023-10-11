module Membership
  module LookupSync
    class << self
      def sync_members(enumerator)
        for m in enumerator
          ulr = UcamLookupRecord.find_or_create_by(member: m)
          ulr.data = ::Membership::Lookup.about(m.crsid)
          m.ucam_lookup_record = ulr
          result = m.ucam_student?
          if result.nil?
            puts "#{m.crsid} was not found in Lookup" if m.graduation_year >= 2013
            next
          elsif result
            if m.mtype_id == 2
              puts "#{m.crsid} is a student"
              new_year = Date.today.month >= 8 ? Date.today.year + 1 : Date.today.year
              m.mtype_id = 1
              m.graduation_year = new_year
            end
          else
            if m.mtype_id == 1
              puts "#{m.crsid} is not a student"
              if m.graduation_year > Date.today.year
                m.graduation_year = Date.today.year
              end
              m.mtype_id = 2
            end
          end
          m.save!
        end
      end
    end
  end
end
