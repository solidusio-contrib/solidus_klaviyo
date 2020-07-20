# frozen_string_literal: true

module SolidusKlaviyo
  module Event
    class Base
      attr_reader :payload

      def initialize(payload = {})
        @payload = payload
      end
    end
  end
end
