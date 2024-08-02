# config/application.rb
require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

require_relative "../lib/middleware/force_json_format"

module TaskManager
  class Application < Rails::Application
    config.load_defaults 7.1

    config.api_only = true

    config.autoload_paths += %W(#{config.root}/lib/middleware)

    config.middleware.use ForceJsonFormat
    config.middleware.use Rack::Attack

    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    config.middleware.delete ActionDispatch::Flash
    config.middleware.delete ActionDispatch::ContentSecurityPolicy::Middleware

    config.after_initialize do
      Rails.logger.info "Rack::Attack cache store: #{Rack::Attack.cache.store}"
    end
  end
end
