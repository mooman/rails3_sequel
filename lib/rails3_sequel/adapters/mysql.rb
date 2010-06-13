module Rails
  module Sequel
    class Database

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

    end
  end
end
