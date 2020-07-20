# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Configuration do
  it 'can be instantiated' do
    expect { described_class.new }.not_to raise_error
  end
end
