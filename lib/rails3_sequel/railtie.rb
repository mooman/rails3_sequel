require 'rails'
require 'active_model/railtie'

# For now, action_controller must always be present with
# rails, so let's make sure that it gets required before
# here. This is needed for correctly setting up the middleware.
# In the future, this might become an optional require.
require "action_controller/railtie"

require 'sequel'
require 'rails3_sequel/database_connection'

module Rails
  module Sequel
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'rails3_sequel/railties/database.rake'
      end
    end
  end
end
