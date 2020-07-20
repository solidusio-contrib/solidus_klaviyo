# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::TrackEventJob do
  it 'tracks the provided event via Klaviyo' do
    order = build_stubbed(:order)
    event_tracker = stub_event_tracker
    event = stub_event(SolidusKlaviyo::Event::StartedCheckout, order: order)

    described_class.perform_now('started_checkout', order: order)

    expect(event_tracker).to have_received(:track).with(event)
  end

  private

  def stub_event_tracker
    event_tracker = instance_spy(SolidusKlaviyo::EventTracker)

    allow(SolidusKlaviyo::EventTracker).to receive(:new).and_return(event_tracker)

    event_tracker
  end

  def stub_event(event_klass, event_payload)
    event = instance_double(event_klass)

    allow(event_klass).to receive(:new).with(event_payload).and_return(event)

    event
  end
end
