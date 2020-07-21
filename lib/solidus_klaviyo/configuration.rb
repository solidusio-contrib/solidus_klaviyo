# frozen_string_literal: true

module SolidusKlaviyo
  class Configuration
    attr_accessor :api_key, :variant_url_builder, :image_url_builder

    def events
      @events ||= {
        'ordered_product' => SolidusKlaviyo::Event::OrderedProduct,
        'placed_order' => SolidusKlaviyo::Event::PlacedOrder,
        'started_checkout' => SolidusKlaviyo::Event::StartedCheckout,
        'cancelled_order' => SolidusKlaviyo::Event::CancelledOrder,
        'reset_password' => SolidusKlaviyo::Event::ResetPassword,
        'created_account' => SolidusKlaviyo::Event::CreatedAccount,
      }
    end
  end
end
