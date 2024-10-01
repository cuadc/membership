module Membership
  module SympaSync
    # Do not ask why the SOAP client and/or server requires particular
    # combinations of namespace, identifier attribute and/or message
    # tag options be set to the values below. It just does in order
    # for anything to work...

    SERVER = 'https://lists.cam.ac.uk/sympa/wsdl'
    LIST = 'soc-adc-members'
    QUIET = true
    ATTRIBUTES = { "xmlns:ns0" => "urn:sympasoap" }

    class << self
      def sync_members(enumerator)
        return unless Rails.env.production?
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

      def remove_member(member)
        return unless Rails.env.production?
        client = Savon.client(wsdl: SERVER, env_namespace: 'soap-env', namespace_identifier: 'ns0', logger: Rails.logger)
        login_msg = { email: ENV['SYMPA_USERNAME'], password: ENV['SYMPA_PASSWORD'] }
        response = client.call(:login, message: login_msg, attributes: ATTRIBUTES, message_tag: :login)
        cookies = HTTPI::Cookie.new(response.http.headers['set-cookie2'].dup)
        response = client.call(:review, message: { 'list' => LIST }, cookies: cookies, attributes: ATTRIBUTES, message_tag: :review)
        subscribers = response.body[:review_response][:return][:item]
        emails = get_all_mem_emails(member)
        emails.each do |email|
          if subscribers.include?(email)
            client.call(:del, message: { 'list' => LIST, 'email' => email, 'quiet' => QUIET }, cookies: cookies, attributes: ATTRIBUTES, message_tag: :del)
          end
        end
      end

      private

      @@email_regexp = /\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/

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
        member.versions.each do |ver|
          emails.concat(ver.changeset["primary_email"] || [])
          emails.concat(ver.changeset["secondary_email"] || [])
          emails.concat((ver.changeset["notes"] || []).reject(&:blank?).map { |str| str.scan(@@email_regexp) }.flatten)
        end
        emails.reject(&:blank?).sort.uniq
      end
    end
  end
end
