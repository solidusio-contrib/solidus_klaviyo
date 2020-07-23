# frozen_string_literal: true

RSpec.describe Spree::User do
  describe '#save' do
    it 'tracks the Signed Up event' do
      user = create(:user)

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'created_account',
        user: user,
      )
    end

    context 'when default_list is set' do
      it 'subscribes the user to the default list' do
        allow(SolidusKlaviyo.configuration).to receive(:default_list)
          .and_return('dummyList')
        properties = { 'first_name' => 'John' }
        allow(SolidusKlaviyo::Serializer::User).to receive(:serialize)
          .and_return(properties)

        user = create(:user)

        expect(SolidusKlaviyo::SubscribeJob).to have_been_enqueued.with(
          'dummyList',
          user.email,
          properties,
        )
      end
    end

    context 'when default_list is not set' do
      it 'does not subscribe the user to any list' do
        allow(SolidusKlaviyo.configuration).to receive(:default_list).and_return(nil)

        create(:user)

        expect(SolidusKlaviyo::SubscribeJob).not_to have_been_enqueued
      end
    end
  end

  describe '#send_reset_password_instructions' do
    it 'tracks the Requested Password Reset event' do
      create(:store)
      user = create(:user)

      user.send_reset_password_instructions

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'reset_password',
        user: user,
        token: an_instance_of(String),
      )
    end

    context 'when disable_builtin_emails is true' do
      it 'does not send the password reset email' do
        allow(SolidusKlaviyo.configuration).to receive(:disable_builtin_emails).and_return(true)
        email = instance_spy('ActionMailer::Delivery')
        allow(Devise.mailer).to receive(:reset_password_instructions).and_return(email)
        create(:store)
        user = create(:user)

        user.send_reset_password_instructions

        expect(email).not_to have_received(:deliver_now)
      end
    end

    context 'when disable_builtin_emails is false' do
      it 'sends the password reset email' do
        allow(SolidusKlaviyo.configuration).to receive(:disable_builtin_emails).and_return(false)
        email = instance_spy('ActionMailer::Delivery')
        allow(Devise.mailer).to receive(:reset_password_instructions).and_return(email)
        create(:store)
        user = create(:user)

        user.send_reset_password_instructions

        expect(email).to have_received(:deliver_now)
      end
    end
  end
end
