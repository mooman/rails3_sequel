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

module Rails
  module Sequel
    class Railtie < Rails::Railtie
      config.generators.orm :sequel, :migration => true, :timestamps => false

      rake_tasks do
        load File.dirname(__FILE__) + '/railties/database.rake'
      end

      initializer 'sequel.initialize_database' do |app|
        Rails::Sequel::Database.configurations = app.config.database_configuration
        Rails::Sequel::Database.connect
      end
    end
  end
end
