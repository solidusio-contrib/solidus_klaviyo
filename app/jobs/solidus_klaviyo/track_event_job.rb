# frozen_string_literal: true

module SolidusKlaviyo
  class TrackEventJob < ApplicationJob
    queue_as :default

    def perform(event_name, event_payload = {})
      event_class = SolidusKlaviyo.configuration.events[event_name]
      raise ArgumentError, "#{event_name} is not a registered Klaviyo event" unless event_class

      event_tracker = SolidusKlaviyo::EventTracker.new
      event = event_class.new(event_payload)

      event_tracker.track(event)
    end
  end
end
