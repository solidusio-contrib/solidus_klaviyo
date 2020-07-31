# frozen_string_literal: true

require 'solidus_klaviyo/testing_support/matchers'

RSpec.describe SolidusKlaviyo::TestingSupport::Matchers do
  describe '.have_tracked' do
    it 'matches when the event was tracked' do
      test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
      test_registry.tracked_events << SolidusKlaviyo::Event::StartedCheckout.new

      expect(test_registry).to have_tracked(SolidusKlaviyo::Event::StartedCheckout)
    end

    it 'fails when the event was not tracked' do
      test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
      test_registry.tracked_events << SolidusKlaviyo::Event::PlacedOrder.new

      expect(test_registry).not_to have_tracked(SolidusKlaviyo::Event::StartedCheckout)
    end

    describe '.with' do
      it 'matches when the event was tracked with the right payload' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.tracked_events << SolidusKlaviyo::Event::StartedCheckout.new(foo: 'bar')

        expect(test_registry).to have_tracked(SolidusKlaviyo::Event::StartedCheckout)
          .with(foo: 'bar')
      end

      it 'fails when the event was tracked with the wrong payload' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.tracked_events << SolidusKlaviyo::Event::StartedCheckout.new(foo: 'baz')

        expect(test_registry).not_to have_tracked(SolidusKlaviyo::Event::StartedCheckout)
          .with(foo: 'bar')
      end
    end
  end

  describe '.have_subscribed' do
    it 'matches when the email was subscribed' do
      test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
      test_registry.subscribed_profiles << { email: 'jdoe@example.com' }

      expect(test_registry).to have_subscribed('jdoe@example.com')
    end

    it 'fails when the email was not subscribed' do
      test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
      test_registry.subscribed_profiles << { email: 'foo@example.com' }

      expect(test_registry).not_to have_subscribed('jdoe@example.com')
    end

    describe '.to' do
      it 'matches when the email was subscribed to the right list' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.subscribed_profiles << { email: 'jdoe@example.com', list_id: 'dummyList' }

        expect(test_registry).to have_subscribed('jdoe@example.com').to('dummyList')
      end

      it 'fails when the email was subscribed to the wrong list' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.subscribed_profiles << { email: 'jdoe@example.com', list_id: 'wrongList' }

        expect(test_registry).not_to have_subscribed('jdoe@example.com').to('dummyList')
      end
    end

    describe '.with' do
      it 'matches when the email was subscribed with the right properties' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.subscribed_profiles << {
          email: 'jdoe@example.com',
          properties: { foo: 'bar' },
        }

        expect(test_registry).to have_subscribed('jdoe@example.com').with(foo: 'bar')
      end

      it 'fails when the email was subscribed with the wrong properties' do
        test_registry = SolidusKlaviyo::TestingSupport::TestRegistry.new
        test_registry.subscribed_profiles << {
          email: 'jdoe@example.com',
          properties: { foo: 'baz' },
        }

        expect(test_registry).not_to have_subscribed('jdoe@example.com').with(foo: 'bar')
      end
    end
  end
end
