module Api
  UtilityError = Class.new(StandardError)

  class BaseUtility
    class << self
      private

      def get_request(endpoint, params = {}, headers = {})
        response = client.get(endpoint, params, headers)

        raise UtilityError, "Failed API request at #{endpoint}" unless response.success?

        response.body
      end

      def client
        return @client if defined?(@client)

        @client = Faraday.new(url: client_url) do |c|
          c.response :json
        end
      end

      def client_url
        raise Api::UtilityError, "no client url defined"
      end
    end
  end
end
