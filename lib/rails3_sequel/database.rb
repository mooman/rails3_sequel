module Rails
  module Sequel
    class Database    

      class << self
        attr_reader :configurations

        def configurations= (config)
          @configurations = config

          for key,env in @configurations do
            # some translations
            env['adapter'] = case env['adapter']
              when 'postgresql' then 'postgres'
              when 'sqlite3'    then 'sqlite'
              else env['adapter']
            end
          end
        end

        def adapter(env)
          a = configurations[env]['adapter']
          a_file = File.join(File.dirname(__FILE__), 'adapters', "#{a}.rb")

          unless File.exists?(a_file)
            raise "Adapter #{a} not supported."
          end

          load a_file
          const_get(a.camelize.to_sym).new(env)
        end

        # convenient methods

        def connect (env, options = {})
          adapter(env).connect(options)
        end

        def create_database (env, options = {})
          local_database?(env) { adapter(env).create_database(options) }
        end

        def create_all (options = {})
          for env,config in configurations do
            next unless config['database']
            create_database(env, options)
          end
        end

        def drop_database (env)
          local_database?(env) { adapter(env).drop_database }
        end

        def drop_all
          for env,config in configurations do
            next unless config['database']
            drop_database(env)
          end
        end

        private

        def local_database? (env, &block)
          config = configurations[env]

          if %w( 127.0.0.1 localhost ).include?(config['host']) || config['host'].blank?
            yield
          else
            $stderr.puts "This task only modifies local databases. #{config['database']} is on a remote host."
          end 
        end
      end

    end
  end
end
