module Rails
  module Sequel
    class Database

      class Postgres
        def initialize (env)
          @env = env
          @config = parse_special_options(Database.configurations[@env])
        end

        def connect (options = {})
          options = parse_special_options(options)
          ::Sequel.connect(@config.merge(options))
        end

        # from ActiveRecord
        def create_database (options = {})
          db = management_connect
          name = @config['database']

          if name.nil? or name.strip == '' then
            raise "No valid database specified for #{@env} environment"
          end

          options = options.reverse_merge(:encoding => "utf8")

          option_string = options.sum do |key, value|
            case key
            when 'owner'
              " OWNER = \"#{value}\""
            when 'template'
              " TEMPLATE = \"#{value}\""
            when 'encoding'
              " ENCODING = '#{value}'"
            when 'tablespace'
              " TABLESPACE = \"#{value}\""
            when :connection_limit
              " CONNECTION LIMIT = #{value}"
            else 
              ""   
            end  
          end  

          # TODO: quote table name
          db.execute "CREATE DATABASE #{name} #{option_string}"

          # create schema too, if the previous command succeeds, this should be fine
          # first connect without schema specified
          db = connect('schema_search_path' => nil)
          for schema in @config['schema_search_path'].split(',') do
            next if schema.strip == 'public'
            db.execute "CREATE SCHEMA #{schema}"
          end
        end

        def drop_database
          db = management_connect
          name = @config['database']

          db.execute "DROP DATABASE #{name}"
        end

        private

        def management_connect
          connect({ 'database' => 'postgres', 'schema_search_path' => 'public' })
        end

        def parse_special_options (opts)
          # not a deep dup
          options = opts.dup

          if options['schema_search_path'].nil? then
            options['after_connect'] = nil
          else
            options['after_connect'] = (
              proc do |conn|
                conn.execute("SET search_path = #{options['schema_search_path']}")
              end
            )
          end

          return options
        end
      end

    end
  end
end
