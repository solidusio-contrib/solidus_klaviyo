# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Subscriber do
  describe '#subscribe' do
    context 'when the request is well-formed' do
      it 'subscribes the given email to the configured list' do
        list_id = 'dummyListId'
        subscriber = described_class.new(list_id)

        VCR.use_cassette('subscriber') do
          email = 'jdoe@example.com'
          subscriber.subscribe(email)
        end

        expect(
          a_request(:post, "https://a.klaviyo.com/api/v2/list/#{list_id}/subscribe")
        ).to have_been_made
      end
    end

    context 'when the request is malformed' do
      it 'raises a SubscriptionError' do
        list_id = 'wrongListId'
        subscriber = described_class.new(list_id)

        VCR.use_cassette('subscriber') do
          email = 'jdoe@example.com'
          expect {
            subscriber.subscribe(email)
          }.to raise_error(described_class::SubscriptionError)
        end
      end
    end
  end
end
