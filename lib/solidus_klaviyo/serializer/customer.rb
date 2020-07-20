# frozen_string_literal: true

module SolidusKlaviyo
  module Serializer
    class Customer < Base
      def order
        object
      end

      def as_json(_options = {})
        if order.user
          { '$email' => order.user.email }
        else
          { '$email' => order.email }
        end
      end
    end
  end
end
