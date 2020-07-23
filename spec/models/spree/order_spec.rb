# frozen_string_literal: true

RSpec.describe Spree::Order do
  describe '#next!' do
    context 'when the order is in the cart state' do
      it 'tracks the Started Checkout event' do
        order = create(:order_with_line_items)

        order.next!

        expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
          'started_checkout',
          order: order,
        )
      end
    end
  end

  describe '#complete!' do
    it 'tracks the Placed Order event' do
      order = Spree::TestingSupport::OrderWalkthrough.up_to(:payment)

      order.complete!

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'placed_order',
        order: order,
      )
    end

    it 'tracks the Ordered Product events' do
      order = Spree::TestingSupport::OrderWalkthrough.up_to(:payment)

      order.complete!

      order.line_items.each do |line_item|
        expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
          'ordered_product',
          line_item: line_item,
        )
      end
    end
  end

  describe '#canceled_by' do
    it 'tracks the Cancelled Order event' do
      order = create(:completed_order_with_totals)

      order.canceled_by(create(:user))

      expect(SolidusKlaviyo::TrackEventJob).to have_been_enqueued.with(
        'cancelled_order',
        order: order,
      )
    end
  end
end
