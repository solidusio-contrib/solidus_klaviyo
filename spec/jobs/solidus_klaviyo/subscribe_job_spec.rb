# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::SubscribeJob do
  it 'subscribes the given email to the given list' do
    subscriber = instance_spy(SolidusKlaviyo::Subscriber)
    list_id = 'dummyListId'
    allow(SolidusKlaviyo::Subscriber).to receive(:new).with(list_id).and_return(subscriber)

    email = 'jdoe@example.com'
    described_class.perform_now(list_id, email)

    expect(subscriber).to have_received(:subscribe).with(email)
  end
end
