require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'

module Sequel
  module Generators
    class Base < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      def self.source_root
        @source_root ||= File.expand_path(File.join(base_name, generator_name, 'templates'), File.dirname(__FILE__))
      end

      protected

      def self.next_migration_number(dirname)
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    class ActiveModel < Rails::Generators::ActiveModel
      def self.all(klass)
        "#{klass}.all" 
      end

      def self.find(klass, params=nil)
        "#{klass}[#{params}]"
      end

      def self.build(klass, params=nil)
        if params then
          "#{klass}.new(#{params})"
        else
          "#{klass}.new"
        end
      end

      def save
        # probably will set raise_on_save_failure to false by default when using Rails
        "#{name}.save"
      end

      def update_attributes(params=nil)
        "#{name}.update(#{params})"
      end

      def errors
        "#{name}.errors"
      end

      def destroy
        "#{name}.destroy"
      end
    end
  end
end
