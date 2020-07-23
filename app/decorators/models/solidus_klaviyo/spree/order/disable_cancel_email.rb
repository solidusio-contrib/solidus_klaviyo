# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module Order
      module DisableCancelEmail
        def send_cancel_email
          super unless SolidusKlaviyo.configuration.disable_builtin_emails
        end
      end
    end
  end
end

Spree::Order.prepend(SolidusKlaviyo::Spree::Order::DisableCancelEmail)
