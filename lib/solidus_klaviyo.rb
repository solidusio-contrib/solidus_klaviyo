# frozen_string_literal: true

require 'httparty'
require 'klaviyo'
require 'solidus_core'
require 'solidus_support'

require 'solidus_klaviyo/version'
require 'solidus_klaviyo/engine'
require 'solidus_klaviyo/configuration'
require 'solidus_klaviyo/event_tracker'
require 'solidus_klaviyo/serializer/base'
require 'solidus_klaviyo/serializer/address'
require 'solidus_klaviyo/serializer/order'
require 'solidus_klaviyo/serializer/line_item'
require 'solidus_klaviyo/serializer/user'
require 'solidus_klaviyo/serializer/customer_properties'
require 'solidus_klaviyo/serializer/shipment'
require 'solidus_klaviyo/serializer/shipping_method'
require 'solidus_klaviyo/serializer/payment'
require 'solidus_klaviyo/serializer/payment_source'
require 'solidus_klaviyo/event/base'
require 'solidus_klaviyo/event/ordered_product'
require 'solidus_klaviyo/event/placed_order'
require 'solidus_klaviyo/event/started_checkout'
require 'solidus_klaviyo/event/cancelled_order'
require 'solidus_klaviyo/event/reset_password'
require 'solidus_klaviyo/event/created_account'
require 'solidus_klaviyo/subscriber'

module SolidusKlaviyo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
