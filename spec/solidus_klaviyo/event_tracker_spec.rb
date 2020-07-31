# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::EventTracker do
  describe '#track' do
    context 'when test_mode is enabled' do
      it 'adds the event to the test registry' do
        allow(SolidusKlaviyo.configuration).to receive(:test_mode).and_return(true)
        event = instance_double(SolidusKlaviyo::Event::StartedCheckout)

        event_tracker = described_class.new
        event_tracker.track(event)

        expect(SolidusKlaviyo.tracked_events).to include(event)
      end
    end

    context 'when test_mode is disabled' do
      it 'tracks the event through the Klaviyo API' do
        klaviyo_client = stub_klaviyo_client
        time = Time.zone.now
        event = instance_double(
          SolidusKlaviyo::Event::StartedCheckout,
          name: 'Started Checkout',
          email: 'jdoe@example.com',
          customer_properties: { '$email' => 'jdoe@example.com' },
          properties: { 'foo' => 'bar' },
          time: time,
        )

        event_tracker = described_class.new
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
  end

  private

  def stub_klaviyo_client
    klaviyo_client = instance_spy(Klaviyo::Client)

    allow(Klaviyo::Client).to receive(:new)
      .with(SolidusKlaviyo.configuration.api_key)
      .and_return(klaviyo_client)

    klaviyo_client
  end
end
