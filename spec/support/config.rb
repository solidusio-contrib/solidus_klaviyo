# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    SolidusKlaviyo.configure do |c|
      c.api_key = 'pk_8abb449a76e904bd067901a275a6672eea'
      c.variant_url_builder = proc do |variant|
        "https://example.com/products/#{variant.product.slug}"
      end
      c.image_url_builder = proc do |variant|
        "https://example.com/products/#{variant.product.slug}.jpg"
      end
    end
  end
end
