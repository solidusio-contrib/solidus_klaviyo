# frozen_string_literal: true

module SolidusKlaviyo
  module Serializer
    class LineItem < Base
      def line_item
        object
      end

      def as_json(_options = {})
        {
          'ProductID' => line_item.variant_id,
          'SKU' => line_item.variant.sku,
          'ProductName' => line_item.variant.descriptive_name,
          'Quantity' => line_item.quantity,
          'ItemPrice' => line_item.price,
          'RowTotal' => line_item.amount,
          'ProductURL' => SolidusKlaviyo.configuration.variant_url_builder.call(line_item.variant),
          'ImageURL' => SolidusKlaviyo.configuration.image_url_builder.call(line_item.variant),
          # rubocop:disable Metrics/LineLength
          'ProductCategories' => line_item.product.taxons.flat_map(&:self_and_ancestors).map(&:name),
          # rubocop:enable Metrics/LineLength
        }
      end
    end
  end
end
