# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module Order
      module DisableConfirmEmail
        def deliver_order_confirmation_email
          super unless SolidusKlaviyo.configuration.disable_builtin_emails
        end
      end
    end
  end
end

if Spree.solidus_gem_version < Gem::Version.new('2.9.0')
  Spree::Order.prepend(SolidusKlaviyo::Spree::Order::DisableConfirmEmail)
end
