# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::UpdateJob do
  include ActiveSupport::Testing::TimeHelpers

  context 'when Klaviyo is not rate-limited' do
    it 'updates the given email on the given list' do
      solidus_klaviyo = class_spy(SolidusKlaviyo)
      stub_const('SolidusKlaviyo', solidus_klaviyo)

      described_class.perform_now('dummyListId', 'jdoe@example.com', first_name: 'John')

      expect(solidus_klaviyo).to have_received(:update_now).with(
        'dummyListId',
        'jdoe@example.com',
        first_name: 'John',
      )
    end
  end

  context 'when Klaviyo is rate-limited' do
    it 'reschedules the job for later' do
      freeze_time do
        allow(SolidusKlaviyo).to receive(:update_now)
          .and_raise(SolidusKlaviyo::RateLimitedError.new(OpenStruct.new(
            headers: { 'retry-after' => 60 },
            parsed_response: { 'detail' => 'error message' },
          )))

        described_class.perform_now('dummyListId', 'jdoe@example.com', first_name: 'John')

        expect(described_class).to have_been_enqueued.with(
          'dummyListId',
          'jdoe@example.com',
          first_name: 'John',
        ).at(60.seconds.from_now)
      end
    end
  end
end
