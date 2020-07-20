# frozen_string_literal: true

module SolidusKlaviyo
  class TrackEventJob < ApplicationJob
    queue_as :default

    def perform(event_class, event_payload = {})
      event_tracker = SolidusKlaviyo::EventTracker.new
      event = "SolidusKlaviyo::Event::#{event_class.camelize}".constantize.new(event_payload)

      event_tracker.track(event)
    end
  end
end
