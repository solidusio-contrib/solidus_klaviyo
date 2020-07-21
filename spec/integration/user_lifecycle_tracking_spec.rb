# frozen_string_literal: true

RSpec.describe 'User lifecycle tracking' do
  it 'records user lifecycle events' do
    VCR.use_cassette(
      'integration/user_lifecycle_tracking',
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:data)],
      allow_playback_repeats: true,
    ) do
      create(:store)

      perform_enqueued_jobs do
        # Created Account
        user = create(:user)

        # Reset Password
        user.send_reset_password_instructions
      end
    end

    expect(
      a_request(:get, /#{Regexp.escape('a.klaviyo.com/crm/api/track')}/)
    ).to have_been_made.times(2)
  end
end
