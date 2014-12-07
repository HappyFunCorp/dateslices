# Be sure to restart your server when you modify this file.

Rails.application.config.assets.version = '1.0'
Rails.application.config.action_dispatch.cookies_serializer = :json
Rails.application.config.filter_parameters += [:password]
Rails.application.config.session_store :cookie_store, key: '_dummy_session'
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
end
