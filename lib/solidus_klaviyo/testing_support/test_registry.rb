# frozen_string_literal: true

module SolidusKlaviyo
  module TestingSupport
    class TestRegistry
      def tracked_events
        @tracked_events ||= []
      end

      def subscribed_profiles
        @subscribed_profiles ||= []
      end
    end
  end
end
