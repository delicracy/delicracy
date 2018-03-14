require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Delicracy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    # Mongoid
    config.generators do |g|
      g.scaffold_stylesheet false
      # g.test_framework :test_unit, fixture: false
      g.orm :mongoid
    end

    # 모델 추가
    %w(accounts statements traders transactions officers).each do |name|
      config.autoload_paths << "#{Rails.root}/app/models/#{name}"
    end

    config.i18n.default_locale = :en
  end
end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular("status", "status")
end
