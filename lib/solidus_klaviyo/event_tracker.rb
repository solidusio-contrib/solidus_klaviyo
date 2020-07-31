# frozen_string_literal: true

module SolidusKlaviyo
  class EventTracker
    def initialize
      @klaviyo = Klaviyo::Client.new(SolidusKlaviyo.configuration.api_key)
    end

    def track(event)
      if SolidusKlaviyo.configuration.test_mode
        SolidusKlaviyo.tracked_events << event
        true
      else
        klaviyo.track(
          event.name,
          email: event.email,
          customer_properties: event.customer_properties,
          properties: event.properties,
          time: event.time,
        )
      end
    end

    private

    attr_reader :klaviyo
  end
end
