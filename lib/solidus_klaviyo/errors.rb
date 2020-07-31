# frozen_string_literal: true

module SolidusKlaviyo
  class UnregisteredEventError < ArgumentError
    def initialize(event_name, *args)
      super("#{event_name} is not a registered Klaviyo event", *args)
    end
  end
end
