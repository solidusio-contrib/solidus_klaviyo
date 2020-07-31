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
require 'solidus_klaviyo/errors'

module SolidusKlaviyo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def track_now(event_name, event_payload = {})
      event = configuration.event_klass!(event_name).new(event_payload)
      EventTracker.new.track(event)
    end

    def track_later(event_name, event_payload = {})
      configuration.event_klass!(event_name) # validate event name
      TrackEventJob.perform_later(event_name, event_payload)
    end

    def subscribe_now(list_id, email, properties = {})
      Subscriber.new(list_id).subscribe(email, properties)
    end

    def subscribe_later(list_id, email, properties = {})
      SubscribeJob.perform_later(list_id, email, properties)
    end
  end
end
