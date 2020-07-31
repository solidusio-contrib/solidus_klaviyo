# frozen_string_literal: true

RSpec.describe SolidusKlaviyo do
  describe '.configuration' do
    it 'returns an instance of the configuration' do
      expect(described_class.configuration).to be_instance_of(SolidusKlaviyo::Configuration)
    end
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect do |b|
        described_class.configure(&b)
      end.to yield_with_args(an_instance_of(SolidusKlaviyo::Configuration))
    end
  end

  describe '.track_now' do
    context 'when the event is registered' do
      # rubocop:disable RSpec/MultipleExpectations
      it 'tracks the event via the event tracker' do
        event_tracker = instance_spy(SolidusKlaviyo::EventTracker)
        allow(described_class.configuration).to receive(:event_klass!)
          .with('custom_event')
          .and_return(OpenStruct)
        allow(SolidusKlaviyo::EventTracker).to receive(:new).and_return(event_tracker)

        described_class.track_now('custom_event', payload_key: 'payload_value')

        expect(event_tracker).to have_received(:track) do |event|
          expect(event).to be_an_instance_of(OpenStruct)
          expect(event.payload_key).to eq('payload_value')
        end
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when the event is not registered' do
      it 'bubbles up any errors' do
        allow(described_class.configuration).to receive(:event_klass!)
          .with('custom_event')
          .and_raise(SolidusKlaviyo::UnregisteredEventError.new('custom_event'))

        expect {
          described_class.track_now('custom_event', foo: 'bar')
        }.to raise_error(SolidusKlaviyo::UnregisteredEventError, /custom_event/)
      end
    end
  end

  describe '.track_later' do
    context 'when the event is registered' do
      it 'enqueues a TrackEventJob' do
        allow(described_class.configuration).to receive(:event_klass!).with('custom_event')

        described_class.track_later('custom_event', foo: 'bar')

        expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with('custom_event', foo: 'bar')
      end
    end

    context 'when the event is not registered' do
      it 'bubbles up any errors' do
        allow(described_class.configuration).to receive(:event_klass!)
          .with('custom_event')
          .and_raise(SolidusKlaviyo::UnregisteredEventError.new('custom_event'))

        expect {
          described_class.track_later('custom_event', foo: 'bar')
        }.to raise_error(SolidusKlaviyo::UnregisteredEventError, /custom_event/)
      end
    end
  end

  describe '.subscribe_now' do
    it 'subscribes the profile to the given list' do
      subscriber = instance_spy(SolidusKlaviyo::Subscriber)
      allow(SolidusKlaviyo::Subscriber).to receive(:new).with('fakeList').and_return(subscriber)

      described_class.subscribe_now('fakeList', 'jdoe@example.com', property: 'value')

      expect(subscriber).to have_received(:subscribe).with('jdoe@example.com', property: 'value')
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
