# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::TrackEventJob do
  it 'tracks the event' do
    solidus_klaviyo = class_spy(SolidusKlaviyo)
    stub_const('SolidusKlaviyo', solidus_klaviyo)

    described_class.perform_now('custom_event', payload_key: 'value')

    expect(solidus_klaviyo).to have_received(:track_now).with('custom_event', payload_key: 'value')
  end
end
