# frozen_string_literal: true

RSpec.describe Spree::User do
  describe '#save' do
    it 'tracks the Signed Up event' do
      user = create(:user)

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'created_account',
        user: user,
      )
    end
  end

  describe '#send_reset_password_instructions' do
    it 'tracks the Requested Password Reset event' do
      create(:store)
      user = create(:user)

      user.send_reset_password_instructions

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'reset_password',
        user: user,
      )
    end
  end
end
