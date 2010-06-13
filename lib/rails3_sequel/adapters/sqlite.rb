module Rails
  module Sequel
    class Database

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
