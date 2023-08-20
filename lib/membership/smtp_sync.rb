module Membership
  module SmtpSync
    class << self
      def sync_members(enumerator)
        for m in enumerator
          result = ::Membership::SmtpCallout.is_accepted?(m.primary_email)
          if result.nil?
            puts "#{m.primary_email} could not be called out"
          else
            m.update!(ucam_mail_accepted: result)
          end
        end
      end
    end
  end
end
