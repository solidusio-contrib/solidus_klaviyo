# frozen_string_literal: true

module SolidusKlaviyo
  class Tracker < SolidusTracking::Tracker
    class << self
      def from_config
        new(api_key: SolidusKlaviyo.configuration.api_key)
      end
    end

    def track(event)
      klaviyo.track(
        event.name,
        email: event.email,
        customer_properties: event.customer_properties,
        properties: event.properties,
        time: event.time,
      )
    end

    private

    def klaviyo
      @klaviyo ||= Klaviyo::Client.new(options.fetch(:api_key))
    end
  end
end
