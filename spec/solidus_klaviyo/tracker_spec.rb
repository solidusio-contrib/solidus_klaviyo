# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Tracker do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration).to receive(:api_key).and_return('test_key')

      tracker = described_class.from_config

      expect(tracker.options[:api_key]).to eq('test_key')
    end
  end

  describe '#track' do
    it 'tracks the event through the Klaviyo API' do
      klaviyo_client = stub_klaviyo_client
      time = Time.zone.now
      event = instance_double(
        SolidusTracking::Event::StartedCheckout,
        name: 'Started Checkout',
        email: 'jdoe@example.com',
        customer_properties: { '$email' => 'jdoe@example.com' },
        properties: { 'foo' => 'bar' },
        time: time,
      )

      event_tracker = described_class.new(api_key: 'test_key')
      event_tracker.track(event)

      expect(klaviyo_client).to have_received(:track).with(
        'Started Checkout',
        email: 'jdoe@example.com',
        customer_properties: { '$email' => 'jdoe@example.com' },
        properties: { 'foo' => 'bar' },
        time: time,
      )
    end
  end

  private

  def stub_klaviyo_client
    instance_spy(Klaviyo::Client).tap do |klaviyo_client|
      allow(Klaviyo::Client).to receive(:new).and_return(klaviyo_client)
    end
  end
end
