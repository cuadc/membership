require 'net/http'

module Membership
  module SmtpCallout
    class << self
      def is_accepted?(email)
        return nil unless email.present?
        body = fetch(email)
        data = JSON.parse(body)
        data = data['result']
      rescue
        return nil
      end

      def fetch(email)
        uri = URI('https://chtj2.user.srcf.net/cgi-bin/callout')
        uri.query = URI.encode_www_form(email: email)
        req = Net::HTTP::Get.new(uri)
        req['Cache-Control'] = 'no-store, max-age=0'
        req['User-Agent'] = "CUADC Membership System/#{Membership::Version.git_desc} (+https://github.com/cuadc/membership)"
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        if res.is_a?(Net::HTTPSuccess)
          res.body
        else
          nil
        end
      end
    end
  end
end
