# frozen_string_literal: true

RSpec.describe Spree::User do
  describe '#save' do
    context 'when default_list is set' do
      it 'subscribes the user to the default list' do
        allow(SolidusKlaviyo.configuration).to receive(:default_list)
          .and_return('dummyList')
        properties = { 'first_name' => 'John' }
        allow(SolidusTracking::Serializer::User).to receive(:serialize)
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
end
