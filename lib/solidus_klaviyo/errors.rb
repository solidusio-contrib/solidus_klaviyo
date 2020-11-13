# frozen_string_literal: true

module SolidusKlaviyo
  class SubscriptionError < RuntimeError
    attr_reader :response

    def initialize(response, *args)
      @response = response

      super(response.parsed_response['detail'], *args)
    end
  end

  class RateLimitedError < RuntimeError
    attr_reader :response, :retry_after

    def initialize(response, *args)
      @response = response
      @retry_after = response.headers['retry-after'].to_i.seconds

      super(response.parsed_response['detail'], *args)
    end
  end
end
