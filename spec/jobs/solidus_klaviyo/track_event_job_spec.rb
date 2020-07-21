# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::TrackEventJob do
  context 'when the provided event is registered' do
    it 'tracks the provided event via Klaviyo' do
      stub_event_class('CustomEvent')
      stub_custom_event('custom_event', CustomEvent)
      event_tracker = stub_event_tracker

      described_class.perform_now('custom_event', payload_key: 'payload_value')

      expect(event_tracker).to have_received(:track).with(an_instance_of(CustomEvent))
    end
  end

  context 'when the provided event is not registered' do
    it 'raises an ArgumentError' do
      expect {
        described_class.perform_now('custom_event', payload_key: 'payload_value')
      }.to raise_error(ArgumentError)
    end
  end

  private

  def stub_event_class(class_name)
    stub_const(class_name, Class.new do
      def initialize(payload = {})
        @payload = payload
      end
    end)
  end

  def stub_custom_event(event_name, event_class)
    allow(SolidusKlaviyo.configuration).to receive(:events).and_wrap_original do |original|
      original.call.merge(event_name.to_s => event_class)
    end
  end

  def stub_event_tracker
    event_tracker = instance_spy(SolidusKlaviyo::EventTracker)

    allow(SolidusKlaviyo::EventTracker).to receive(:new).and_return(event_tracker)

    event_tracker
  end
end
