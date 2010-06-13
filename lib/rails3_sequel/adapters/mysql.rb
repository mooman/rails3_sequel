module Rails
  module Sequel
    class Database

      class Mysql
        def initialize (env)
          @env = env
          @config = Database.configurations[@env]
        end

        def connect (options = {})
          ::Sequel.connect(@config.merge(options))
        end       

        def create_database (options = {})
          db = management_connect
          name = @config['database']

          if options[:collation]
            db.execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}` COLLATE `#{options[:collation]}`"
          else
            db.execute "CREATE DATABASE `#{name}` DEFAULT CHARACTER SET `#{options[:charset] || 'utf8'}`"
          end 
        end

        def drop_database
          db = management_connect
          name = @config['database']
          db.execute "DROP DATABASE IF EXISTS `#{name}`"
        end

        private

        def management_connect
          connect('database' => nil)
        end
      end

    end
  end
end
