module Membership
  module Camdram
    class << self
      def client
        @client ||= ::Camdram::Client.new do |config|
          app_id = ENV['CAMDRAM_APP_ID']
          app_secret = ENV['CAMDRAM_APP_SECRET']
          config.client_credentials(app_id, app_secret)
          config.user_agent = "CUADC Membership System/#{Membership::Version.git_desc}"
          config.base_url = "https://www.camdram.net"
        end
      end

      def url_for(entity)
        client.base_url + entity.url_slug.chomp('.json')
      end
    end
  end
end
