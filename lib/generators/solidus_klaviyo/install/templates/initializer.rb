# frozen_string_literal: true

SolidusKlaviyo.configure do |config|
  # Your Klaviyo API key, in order to communicate with the Klaviyo API.
  config.api_key = 'YOUR_KLAVIYO_API_KEY'

  # A proc that accepts a variant and returns the URL of that variant's PDP.
  config.variant_url_builder = proc do |variant|
    Spree::Core::Engine.routes.url_helpers.edit_password_url(
      variant.product,
      protocol: 'https',
      host: Spree::Store.default.url,
    )
  end

  # A proc that accepts a variant and returns the URL of that variant's main image.
  config.image_url_builder = proc do |variant|
    image = variant.gallery.images.first
    image&.attachment&.url(:product)
  end

  # A proc that accepts a user and password reset token and returns the URL for completing
  # the password reset procedure.
  config.password_reset_url_builder = proc do |_user, token|
    Spree::Core::Engine.routes.url_helpers.edit_password_url(
      protocol: 'https',
      host: Spree::Store.default.url,
      reset_password_token: token,
    )
  end

  # A proc that accepts an order and returns the URL for tracking the order's status.
  config.order_url_builder = proc do |order|
    Spree::Core::Engine.routes.url_helpers.order_url(
      order,
      protocol: 'https',
      host: Spree::Store.default.url,
    )
  end

  # A Klaviyo list that all users will be subscribed to when they sign up.
  # config.default_list = 'KLAVIYO_LIST_ID'

  # You can register custom events or override the defaults by manipulating the `events` hash.
  # config.events['my_custom_event'] = MyApp::KlaviyoEvents::MyCustomEvent
  # config.events['placed_order'] = MyApp::KlaviyoEvents::PlacedOrder
end
