# frozen_string_literal: true

SolidusKlaviyo.configure do |config|
  # Your Klaviyo API key, in order to communicate with the Klaviyo API.
  config.api_key = 'YOUR_KLAVIYO_API_KEY'

  # A proc that accepts a variant and returns the URL of that variant's PDP.
  config.variant_url_builder = proc do |variant|
    "https://example.com/products/#{variant.product.slug}"
  end

  # A proc that accepts a variant and returns the URL of that variant's main image.
  config.image_url_builder = proc do |variant|
    (variant.images.first || variant.product.images.first)&.attachment&.url(:product)
  end
end
