# frozen_string_literal: true

RSpec.describe 'Order lifecycle tracking' do
  it 'records order lifecycle events' do
    VCR.use_cassette(
      'integration/order_lifecycle_tracking',
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:data)],
      allow_playback_repeats: true,
    ) do
      canceler = create(:user)

      perform_enqueued_jobs do
        # Started Checkout
        order = Spree::TestingSupport::OrderWalkthrough.up_to(:payment)

        # Placed Order + Ordered Product
        order.complete!

        # Cancelled Order
        order.canceled_by(canceler)
      end
    end

    expect(
      a_request(:get, /#{Regexp.escape('a.klaviyo.com/crm/api/track')}/)
    ).to have_been_made.times(4)
  end
end
