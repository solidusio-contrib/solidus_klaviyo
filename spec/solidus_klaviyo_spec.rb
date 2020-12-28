# frozen_string_literal: true

RSpec.describe SolidusKlaviyo do
  describe '.subscribe_now' do
    it 'subscribes the profile to the given list' do
      allow(described_class.configuration).to receive(:api_key).and_return('test_key')
      subscriber = instance_spy(SolidusKlaviyo::Subscriber)
      allow(described_class).to receive(:subscriber) { subscriber }

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

  describe '.update_now' do
    it 'updates the profile on the given list' do
      allow(described_class.configuration).to receive(:api_key).and_return('test_key')
      subscriber = instance_spy(SolidusKlaviyo::Subscriber)
      allow(described_class).to receive(:subscriber) { subscriber }

      described_class.update_now('fakeList', 'jdoe@example.com', property: 'value')

      expect(subscriber).to have_received(:update).with(
        'fakeList',
        'jdoe@example.com',
        property: 'value',
      )
    end
  end

  describe '.update_later' do
    it 'enqueues a UpdateJob' do
      described_class.update_later('fakeList', 'jdoe@example.com', property: 'value')

      expect(SolidusKlaviyo::UpdateJob).to have_been_enqueued.with(
        'fakeList',
        'jdoe@example.com',
        property: 'value',
      )
    end
  end
end
