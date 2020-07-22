# frozen_string_literal: true

module SolidusKlaviyo
  class Subscriber
    class SubscriptionError < RuntimeError; end

    attr_reader :list_id

    def initialize(list_id)
      @list_id = list_id
    end

    def subscribe(email)
      response = HTTParty.post(
        "https://a.klaviyo.com/api/v2/list/#{list_id}/subscribe",
        body: {
          api_key: SolidusKlaviyo.configuration.api_key,
          profiles: ['email' => email],
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
