# frozen_string_literal: true

module SolidusKlaviyo
  module Event
    class ResetPassword < Base
      def name
        'Reset Password'
      end

      delegate :email, to: :user

      def customer_properties
        Serializer::CustomerProperties.serialize(user)
      end

      def properties
        Serializer::User.serialize(user).merge(
          '$event_id' => "#{user.id}-#{user.reset_password_sent_at.to_i}",
          'PasswordResetToken' => token,
        )
      end

      def time
        user.reset_password_sent_at
      end

      private

      def user
        payload.fetch(:user)
      end

      def token
        payload.fetch(:token)
      end
    end
  end
end
