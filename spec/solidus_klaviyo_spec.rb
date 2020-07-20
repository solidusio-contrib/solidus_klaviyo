# frozen_string_literal: true

RSpec.describe SolidusKlaviyo do
  describe '.configuration' do
    it 'returns an instance of the configuration' do
      expect(described_class.configuration).to be_instance_of(SolidusKlaviyo::Configuration)
    end
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect do |b|
        described_class.configure(&b)
      end.to yield_with_args(an_instance_of(SolidusKlaviyo::Configuration))
    end
  end
end
