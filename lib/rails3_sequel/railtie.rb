require 'pp'
require 'rails'
require 'active_model/railtie'

# For now, action_controller must always be present with
# rails, so let's make sure that it gets required before
# here. This is needed for correctly setting up the middleware.
# In the future, this might become an optional require.
require "action_controller/railtie"

require 'sequel'
require File.dirname(__FILE__) + '/database'
require File.dirname(__FILE__) + '/railties/controller_runtime'
require File.dirname(__FILE__) + '/railties/log_subscriber'
require File.dirname(__FILE__) + '/railties/benchmarking_mixin'

module Rails
  module Sequel
    class Railtie < Rails::Railtie
      config.generators.orm :sequel, :migration => true, :timestamps => false

      rake_tasks do
        load File.dirname(__FILE__) + '/railties/database.rake'
      end

      log_subscriber :sequel, Rails::Sequel::Railties::LogSubscriber.new

      initializer 'sequel.initialize_database' do |app|
        Rails::Sequel::Database.configurations = app.config.database_configuration
        Rails::Sequel::Database.connect
      end

      initializer 'sequel.logger' do 
        # in additition to user specified logger in the database.yml (if any),
        # also add the Rails logger
        ::Sequel::Model.db.loggers << ::Rails.logger
      end

      initializer 'sequel.log_runtime' do |app|
        ActionController::Base.send :include, Rails::Sequel::Railties::ControllerRuntime
      end

      config.after_initialize do
        ::Sequel::Model.plugin :active_model
        ::Sequel::Model.db.extend Rails::Sequel::Benchmarking
      end
    end
  end
end
