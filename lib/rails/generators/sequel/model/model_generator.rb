require 'rails/generators/sequel'

module Sequel
  module Generators
    class ModelGenerator < Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      check_class_collision

      class_option :migration, :type => :boolean
      class_option :timestamps, :type => :boolean
      # TODO: parent option?

      def create_migration_file
        return unless options[:migration] && options[:parent].nil?
        migration_template 'migration.rb', "db/migrate/create_#{table_name}.rb"
      end

      def create_model_file
        template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      end

      hook_for :test_framework

    end
  end
end
