# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Event::ResetPassword do
  describe '#name' do
    it 'returns the name of the event' do
      user = build_stubbed(:user)

      event = described_class.new(user: user)

      expect(event.name).to eq('Reset Password')
    end
  end

  describe '#email' do
    it 'returns the email on the user' do
      user = build_stubbed(:user)

      event = described_class.new(user: user)

      expect(event.email).to eq(user.email)
    end
  end

  describe '#customer_properties' do
    it 'returns the serialized user information' do
      user = build_stubbed(:user)
      allow(SolidusKlaviyo::Serializer::User).to receive(:serialize)
        .with(user)
        .and_return('Full Name' => 'John Doe')

      event = described_class.new(user: user)

      expect(event.customer_properties).to include('Full Name' => 'John Doe')
    end

    it "uses the user's email for identification" do
      user = build_stubbed(:user)
      allow(SolidusKlaviyo::Serializer::User).to receive(:serialize)
        .with(user)
        .and_return('Full Name' => 'John Doe')

      event = described_class.new(user: user)

      expect(event.customer_properties).to include('$email' => user.email)
    end
  end

  describe '#properties' do
    it 'includes the serialized customer information' do
      user = build_stubbed(:user)
      allow(SolidusKlaviyo::Serializer::User).to receive(:serialize)
        .with(user)
        .and_return('Full Name' => 'John Doe')

      event = described_class.new(user: user)

      expect(event.properties).to include('Full Name' => 'John Doe')
    end

    it 'includes an event ID' do
      user = build_stubbed(:user)
      allow(SolidusKlaviyo::Serializer::User).to receive(:serialize)
        .with(user)
        .and_return('Full Name' => 'John Doe')

      event = described_class.new(user: user)

      expect(event.properties).to include(
        '$event_id' => an_instance_of(String),
      )
    end
  end

  describe '#time' do
    it "returns the time the reset email was sent" do
      user = build_stubbed(:user, reset_password_sent_at: Time.zone.now)

      event = described_class.new(user: user)

      expect(event.time).to eq(user.reset_password_sent_at)
    end
  end
end
