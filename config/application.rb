require_relative "boot"

# Require only the frameworks you want to use, instead of requiring "rails/all"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie" 
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require the custom middleware
require_relative "../lib/middleware/force_json_format"

module TaskManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Only loads a smaller set of middleware suitable for API only apps.
    config.api_only = true

    # Add lib/middleware to the autoload paths
    config.autoload_paths += %W(#{config.root}/lib/middleware)

    # Add the ForceJsonFormat middleware
    config.middleware.use ForceJsonFormat

    # Configurar um session store, necessário para Devise
    config.session_store :cookie_store, key: '_interslice_session'

    # Middleware para gerenciar cookies e sessões
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Remove middlewares desnecessários
    config.middleware.delete ActionDispatch::Flash
    config.middleware.delete ActionDispatch::ContentSecurityPolicy::Middleware

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
