# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Configuration do
  it 'can be instantiated' do
    expect { described_class.new }.not_to raise_error
  end

  it 'allows registering custom events' do
    configuration = described_class.new

    configuration.events['custom_event'] = OpenStruct

    expect(configuration.events['custom_event']).to eq(OpenStruct)
  end
end
