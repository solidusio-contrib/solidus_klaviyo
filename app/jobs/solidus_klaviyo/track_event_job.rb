# frozen_string_literal: true

module SolidusKlaviyo
  class TrackEventJob < ApplicationJob
    queue_as :default

    def perform(event_name, event_payload = {})
      SolidusKlaviyo.track_now(event_name, event_payload)
    end
  end
end
