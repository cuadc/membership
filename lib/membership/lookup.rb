require 'net/http'

module Membership
  module Lookup
    class << self
      def about(crsid)
        return nil unless crsid.present?
        body = fetch(crsid)
        data = JSON.parse(body)
        data = data['result']['person']
        if data.present?
          data.delete('identifier')
          data
        end
      rescue
        return nil
      end

      def is_student?(crsid)
        data = about(crsid)
        !data['cancelled'] && data['student']
      rescue
        return nil
      end

      def fetch(crsid)
        uri = URI('https://chtj2.user.srcf.net/cgi-bin/lookup')
        uri.query = URI.encode_www_form(crsid: crsid)
        req = Net::HTTP::Get.new(uri)
        req['Cache-Control'] = 'no-store, max-age=0'
        req['User-Agent'] = "CUADC Membership System/#{Membership::Version.git_desc} (+https://github.com/cuadc/membership)"
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
