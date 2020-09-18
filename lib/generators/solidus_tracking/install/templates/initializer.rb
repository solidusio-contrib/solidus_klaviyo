# frozen_string_literal: true

SolidusKlaviyo.configure do |config|
  # Your Klaviyo API key, in order to communicate with the Klaviyo API.
  config.api_key = 'YOUR_KLAVIYO_API_KEY'

  # A Klaviyo list that all users will be subscribed to when they sign up.
  # config.default_list = 'KLAVIYO_LIST_ID'
end
