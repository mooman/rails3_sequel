require 'rails/generators/active_model'

module Sequel
  module Generators
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
        "#{name}.save(#{params}, :changed => true)"
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
