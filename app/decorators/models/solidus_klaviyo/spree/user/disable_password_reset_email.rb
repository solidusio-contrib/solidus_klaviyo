# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module User
      module DisablePasswordResetEmail
        def send_reset_password_instructions_notification(token)
          super unless SolidusKlaviyo.configuration.disable_builtin_emails
        end
      end
    end
  end
end

Spree.user_class.prepend(SolidusKlaviyo::Spree::User::DisablePasswordResetEmail)
