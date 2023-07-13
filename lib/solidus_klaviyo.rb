# frozen_string_literal: true

require 'httparty'
require 'klaviyo'
require 'solidus_core'
require 'solidus_support'
require 'solidus_tracking'

require 'solidus_klaviyo/version'
require 'solidus_klaviyo/engine'
require 'solidus_klaviyo/configuration'
require 'solidus_klaviyo/tracker'
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

    def subscribe_now(list_id, email, properties = {})
      subscriber.subscribe(list_id, email, properties)
    end

    def subscribe_later(list_id, email, properties = {})
      SolidusKlaviyo::SubscribeJob.perform_later(list_id, email, properties)
    end

    def update_now(list_id, email, properties = {})
      subscriber.update(list_id, email, properties)
    end

    def update_later(list_id, email, properties = {})
      SolidusKlaviyo::UpdateJob.perform_later(list_id, email, properties)
    end

    def bulk_update_now(list_id, profiles)
      subscriber.bulk_update(list_id, profiles)
    end

    def bulk_update_later(list_id, profiles)
      SolidusKlaviyo::BulkUpdateJob.perform_later(list_id, profiles)
    end

    private

    def subscriber
      @subscriber ||= KlaviyoAPI
    end
  end
end
