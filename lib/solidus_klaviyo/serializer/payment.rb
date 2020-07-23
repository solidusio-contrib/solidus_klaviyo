# frozen_string_literal: true

module SolidusKlaviyo
  module Serializer
    class Payment < Base
      def payment
        object
      end

      def as_json(_options = {})
        {
          'Amount' => payment.amount,
          'State' => payment.state,
          'Number' => payment.number,
          'Source' => PaymentSource.serialize(payment.source),
        }
      end
    end
  end
end
