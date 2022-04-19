require 'net/http'

module Membership
  module Lookup
    class << self
      def about(crsid)
        body = fetch(crsid)
        data = JSON.parse(body)
        data = data['result']['person']
        data.delete('identifier')
        data
      end

      def fetch(crsid)
        uri = URI('https://chtj2.user.srcf.net/cgi-bin/lookup')
        uri.query = URI.encode_www_form(crsid: crsid)
        req = Net::HTTP::Get.new(uri)
        req.basic_auth ENV['LOOKUP_API_USERNAME'], ENV['LOOKUP_API_PASSWORD']
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
