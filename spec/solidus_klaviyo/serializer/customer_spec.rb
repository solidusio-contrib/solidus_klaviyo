# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Serializer::Customer do
  describe '.serialize' do
    it "serializes the order's customer" do
      order = build_stubbed(:order)

      expect(described_class.serialize(order)).to be_instance_of(Hash)
    end
  end
end
