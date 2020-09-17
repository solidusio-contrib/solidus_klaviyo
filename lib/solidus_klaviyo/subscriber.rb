# frozen_string_literal: true

module SolidusKlaviyo
  class Subscriber
    attr_reader :api_key

    class << self
      def from_config
        new(api_key: SolidusKlaviyo.configuration.api_key)
      end
    end

    def initialize(api_key:)
      @api_key = api_key
    end

    def subscribe(list_id, email, properties = {})
      response = HTTParty.post(
        "https://a.klaviyo.com/api/v2/list/#{list_id}/subscribe",
        body: {
          api_key: api_key,
          profiles: [properties.merge('email' => email)],
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      )

      response.success? || raise(SubscriptionError, response.parsed_response['detail'])
    end
  end
end
