# frozen_string_literal: true

module SolidusKlaviyo
  class BulkUpdateJob < ApplicationJob
    queue_as :default

    def perform(list_id, profiles)
      SolidusKlaviyo.bulk_update_now(list_id, profiles)
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(list_id, profiles)
    end
  end
end
