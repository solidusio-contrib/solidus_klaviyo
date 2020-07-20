# frozen_string_literal: true

RSpec.describe 'Order lifecycle tracking' do
  it 'records order lifecycle events' do
    VCR.use_cassette(
      'integration/order_lifecycle_tracking',
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:data)],
      allow_playback_repeats: true,
    ) do
      perform_enqueued_jobs do
        order = Spree::TestingSupport::OrderWalkthrough.up_to(:payment)
        order.complete!
      end
    end

    expect(
      a_request(:get, /#{Regexp.escape('a.klaviyo.com/crm/api/track')}/)
    ).to have_been_made.times(3)
  end
end
