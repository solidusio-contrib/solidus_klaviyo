# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module User
      module TrackSignup
        def self.prepended(base)
          base.after_commit :track_signup, on: :create
        end

        private

        def track_signup
          SolidusKlaviyo.track_later 'created_account', user: self
        end
      end
    end
  end
end

Spree.user_class.prepend(SolidusKlaviyo::Spree::User::TrackSignup)
