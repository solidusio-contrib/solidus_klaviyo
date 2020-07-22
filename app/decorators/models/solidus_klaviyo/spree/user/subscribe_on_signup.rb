# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module User
      module SubscribeOnSignup
        def self.prepended(base)
          base.after_commit :subscribe_to_klaviyo, on: :create
        end

        private

        def subscribe_to_klaviyo
          return unless SolidusKlaviyo.configuration.default_list

          SolidusKlaviyo::SubscribeJob.perform_later(
            SolidusKlaviyo.configuration.default_list,
            email,
            SolidusKlaviyo::Serializer::User.serialize(self),
          )
        end
      end
    end
  end
end

Spree.user_class.prepend(SolidusKlaviyo::Spree::User::SubscribeOnSignup)
