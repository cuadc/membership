module Membership
  module SympaSync
    SERVER = 'https://lists.cam.ac.uk/sympa/wsdl'
    LIST = 'soc-adc-members'
    QUIET = true
    ATTRIBUTES = { "xmlns:ns0" => "urn:sympasoap" }

    class << self
      def sync_members(enumerator)
        # Don't do anything unless we're in prod
        return unless Rails.env.production?

        # Do not ask why the SOAP client and/or server requires
        # this particular combination of namespaces, identifiers
        # attributes and message tags to be set to the values below.
        # It just does in order for anything to work...
        client = Savon.client(wsdl: SERVER, env_namespace: 'soap-env', namespace_identifier: 'ns0', logger: Rails.logger)
        login_msg = { email: ENV['SYMPA_USERNAME'], password: ENV['SYMPA_PASSWORD'] }
        response = client.call(:login, message: login_msg, attributes: ATTRIBUTES, message_tag: :login)
        cookies = HTTPI::Cookie.new(response.http.headers['set-cookie2'].dup)

        response = client.call(:review, message: { 'list' => LIST }, cookies: cookies, attributes: ATTRIBUTES, message_tag: :review)
        subscribers = response.body[:review_response][:return][:item]

        for member in enumerator
          emails = get_all_mem_emails(member)
          emails.delete(member.contact_email)
          emails.each do |email|
            if subscribers.include?(email)
              client.call(:del, message: { 'list' => LIST, 'email' => email, 'quiet' => QUIET }, cookies: cookies, attributes: ATTRIBUTES, message_tag: :del)
            end
          end
          next if member.contact_email.blank?
          next if member.contact_email.start_with?("unknown-member-email-") && member.contact_email.end_with?("@cuadc.org")
          unless subscribers.include?(member.contact_email)
            client.call(:add, message: { 'list' => LIST, 'email' => member.contact_email, 'gecos' => member.name, 'quiet' => QUIET }, cookies: cookies, attributes: ATTRIBUTES, message_tag: :add)
          end
        end
        nil
      end

      private

      def get_all_mem_emails(member)
        emails = [
          member.primary_email,
          member.secondary_email
        ]
        if member.crsid.present?
          emails.concat([
            "#{member.crsid}@cam.ac.uk",
            "#{member.crsid}@alumni.cam.ac.uk",
            "#{member.crsid}@cantab.ac.uk",
            "#{member.crsid}@cantab.net"
          ])
        end
        emails.reject(&:blank?).sort.uniq
      end
    end
  end
end
