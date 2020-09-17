# frozen_string_literal: true

RSpec.describe SolidusKlaviyo do
  describe '.subscribe_now' do
    it 'subscribes the profile to the given list' do
      allow(described_class.configuration).to receive(:api_key).and_return('test_key')
      subscriber = instance_spy(SolidusKlaviyo::Subscriber)
      allow(SolidusKlaviyo::Subscriber).to receive(:new)
        .with(api_key: 'test_key')
        .and_return(subscriber)

      described_class.subscribe_now('fakeList', 'jdoe@example.com', property: 'value')

      expect(subscriber).to have_received(:subscribe).with(
        'fakeList',
        'jdoe@example.com',
        property: 'value',
      )
    end
  end

  describe '.subscribe_later' do
    it 'enqueues a SubscribeJob' do
      described_class.subscribe_later('fakeList', 'jdoe@example.com', property: 'value')

      expect(SolidusKlaviyo::SubscribeJob).to have_been_enqueued.with(
        'fakeList',
        'jdoe@example.com',
        property: 'value',
      )
    end
  end
end
