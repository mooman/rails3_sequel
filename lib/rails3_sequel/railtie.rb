require 'rails'
require 'active_model/railtie'

# For now, action_controller must always be present with
# rails, so let's make sure that it gets required before
# here. This is needed for correctly setting up the middleware.
# In the future, this might become an optional require.
require "action_controller/railtie"

require 'sequel'
require 'rails3_sequel/database'
require 'rails3_sequel/logging'
require 'rails3_sequel/railties/controller_runtime'
require 'rails3_sequel/railties/log_subscriber'

module Rails
  module Sequel
    class Railtie < Rails::Railtie
      log_subscriber :sequel, Rails::Sequel::Railties::LogSubscriber.new

      config.generators.orm :sequel, :autoincrement => false, :migration => true, :timestamps => false

      config.log_warn_duration = nil
      config.rails_fancy_pants_logging = true
      config.loggers = []

      rake_tasks do
        load 'rails3_sequel/railties/database.rake'
      end

      initializer 'sequel.initialize_database' do |app|
        Rails::Sequel::Database.configurations = app.config.database_configuration
        Rails::Sequel::Database.connect(Rails.env)
      end

      initializer 'sequel.logging' do |app|
        if app.config.rails_fancy_pants_logging then
          ::Sequel::Model.db.loggers << Rails.logger
          ::Sequel::Model.db.extend Rails::Sequel::Logging
          ActionController::Base.send :include, Rails::Sequel::Railties::ControllerRuntime
        end

        # additional loggers
        ::Sequel::Model.db.loggers.concat(app.config.loggers)
      end

      config.after_initialize do
        # set some sensible Rails defaults
        ::Sequel::Model.plugin :active_model
        ::Sequel::Model.plugin :validation_helpers

        ::Sequel::Model.raise_on_save_failure = false
      end
    end
  end
end
