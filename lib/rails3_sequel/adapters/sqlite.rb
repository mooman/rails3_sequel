module Rails
  module Sequel
    class Database

      class Sqlite
        def initialize (env)
          @env = env
          @config = Database.configurations[@env]
        end

        def connect (options = {})
          ::Sequel.connect(@config.merge(options))
        end

        def create_database (*args)
          connect
          puts 'Warning: sqlite file may not have been created until there are some operations on it'
        end

        def drop_database (*args)
          dbfile = @config['database']
          File.delete(dbfile) if File.exists?(dbfile)
        end
      end

    end
  end
end
