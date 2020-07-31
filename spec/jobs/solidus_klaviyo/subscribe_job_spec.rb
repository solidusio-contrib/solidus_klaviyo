# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::SubscribeJob do
  it 'subscribes the given email to the given list' do
    solidus_klaviyo = class_spy(SolidusKlaviyo)
    stub_const('SolidusKlaviyo', solidus_klaviyo)

    described_class.perform_now('dummyListId', 'jdoe@example.com', first_name: 'John')

    expect(solidus_klaviyo).to have_received(:subscribe_now).with(
      'dummyListId',
      'jdoe@example.com',
      first_name: 'John',
    )
  end
end
