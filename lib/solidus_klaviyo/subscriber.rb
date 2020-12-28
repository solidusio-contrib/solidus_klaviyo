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
      request(list_id, email, properties, "subscribe")
    end

    def update(list_id, email, properties = {})
      request(list_id, email, properties, "members")
    end

    private

    def request(list_id, email, properties, object)
      response = HTTParty.post(
        "https://a.klaviyo.com/api/v2/list/#{list_id}/#{object}",
        body: {
          api_key: api_key,
          profiles: [properties.merge('email' => email)],
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      )

      unless response.success?
        case response.code
        when 429
          raise(RateLimitedError, response)
        else
          raise(SubscriptionError, response)
        end
      end

      response
    end
  end
end
