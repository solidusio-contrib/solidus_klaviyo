# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module User
      module TrackPasswordReset
        def send_reset_password_instructions
          token = super
          SolidusKlaviyo::TrackEventJob.perform_later 'reset_password', user: self, token: token
          token
        end
      end
    end
  end
end

Spree.user_class.prepend(SolidusKlaviyo::Spree::User::TrackPasswordReset)
