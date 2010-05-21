module Rails
  module Sequel
    module Database    
      mattr_reader :configurations

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

      # Connects to database using constructed Database Connection URI
      def self.connect
        ::Sequel.connect(self.configurations[Rails.env])
      end
    end
  end
end
