# frozen_string_literal: true

require 'rspec/expectations'

module SolidusKlaviyo
  module TestingSupport
    module Matchers
      extend RSpec::Matchers::DSL

      matcher :have_tracked do |klass|
        match do |actual|
          actual.tracked_events.any? do |event|
            event.is_a?(klass) &&
              (!@payload || values_match?(@payload, event.payload))
          end
        end

        chain :with do |payload|
          @payload = payload
        end
      end

      matcher :have_subscribed do |email|
        match do |actual|
          actual.subscribed_profiles.any? do |profile|
            values_match?(email, profile[:email]) &&
              (!@list_id || values_match?(@list_id, profile[:list_id])) &&
              (!@properties || values_match?(@properties, profile[:properties]))
          end
        end

        chain :to do |list_id|
          @list_id = list_id
        end

        chain :with do |properties|
          @properties = properties
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include SolidusKlaviyo::TestingSupport::Matchers
end
