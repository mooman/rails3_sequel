require 'rails/generators/named_base'
require 'rails/generators/migration'

require 'rails/generators/sequel/active_model'

# override Rails::Generators::GeneratedAttribute
require 'rails/generators/sequel/generated_attribute'

module Sequel
  module Generators
    class Base < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      def self.source_root
        @source_root ||= File.expand_path(File.join(base_name, generator_name, 'templates'), File.dirname(__FILE__))
      end

      def cpk
        if @primary_keys and !@primary_keys.empty? then
          "primary_key([#{@primary_keys.map {|pk| ':' + pk}.join(', ')}])"
        end
      end

      protected

      def parse_attributes!
        @primary_keys ||= []

        self.attributes = (attributes || []).map do |key_value|
          name, type, pk = key_value.split(':')
          @primary_keys << name unless pk.nil?
          Rails::Generators::GeneratedAttribute.new(name, type)
        end
      end

      def self.next_migration_number(dirname)
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
