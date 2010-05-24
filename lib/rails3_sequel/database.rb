module Rails
  module Sequel
    module Database    
      mattr_reader :configurations, :db

      def self.configurations= (config)
        @@configurations = config

        for key,env in @@configurations do
          # some translations
          env['adapter'] = case env['adapter']
            when 'postgresql' then 'postgres'
            when 'sqlite3'    then 'sqlite'
            else env['adapter']
          end
        end
      end

      # Connects to database
      def self.connect (options = {})
        @@db = ::Sequel.connect(self.configurations[Rails.env].merge(options))
      end

      def self.create_database (options = {})
        adapter.new.create_database(self.configurations[Rails.env]['database'], options)
      end

      def self.drop_database
        adapter.new.drop_database(self.configurations[Rails.env]['database'])
      end

      class << self
        private

        def adapter
          a = configurations[Rails.env]['adapter'].camelize.to_sym

          unless const_defined?(a)
            raise "Adapter #{a} not supported."
          end

          const_get(a)
        end
      end

      class Postgres
        def initialize
          @db = Rails::Sequel::Database.connect({ :database => 'postgres', :after_connect => ( 
              proc do |conn|
                conn.execute('SET search_path = public')
              end
            )
          })
        end

        # from ActiveRecord
        def create_database (name, options = {})
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
          @db.execute "CREATE DATABASE #{name} #{option_string}"
        end

        def drop_database (name)
          begin
            @db.execute "DROP DATABASE #{name}"
          rescue Sequel::DatabaseError
            raise 'Cannot drop database'
          end
        end
      end

      class Mysql
        def initialize
          Rails::Sequel::Database.connect({ :database => nil })
        end       

        def create_database (name, options = {})
          if options[:collation]
            @db.execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}` COLLATE `#{options[:collation]}`"
          else
            @db.execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}`"
          end 
        end

        def drop_database (name)
          @db.execute "DROP DATABASE IF EXISTS `#{name}`"
        end
      end

      class Sqlite
        def initialize
          Rails::Sequel::Database.connect
        end

        def create_database (*args)
        end

        def drop_database (*args)
        end
      end

    end
  end
end
