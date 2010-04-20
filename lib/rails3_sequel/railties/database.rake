namespace :db do
  def migrations_path
    File.join(RAILS_ROOT, 'db', 'migrate')
  end

  desc "Retrieves the current schema version number"
  task :version => :environment do
    puts "Current version: #{Sequel::Migrator.get_current_migration_version(Sequel::Model.db)}"
  end

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x."
  task :migrate => :environment do
    if ENV['VERSION']
      Sequel::Migrator.apply(Sequel::Model.db, migrations_path, ENV['VERSION'].to_i)
    else
      Sequel::Migrator.apply(Sequel::Model.db, migrations_path)
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n. This is an alias to db:migrate:down.'
  task :rollback => 'db:migrate:down'

  namespace :migrate do
    desc 'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x.'
    task :redo => [ 'db:migrate:down', 'db:migrate' ]

    desc 'Migrate up. Alias to db:migrate'
    task :up => 'db:migrate'

    desc 'Migrate down. Define either VERSION or STEP. VERSION takes precedence if both are defined. STEP=1 if neither are defined'
    task :down => :environment do
      if ENV['VERSION'] then
        version = ENV['VERSION'].to_i
      else
        step = ENV['STEP'] ? ENV['STEP'].to_i : 1
        version = Sequel::Migrator.get_current_migration_version(Sequel::Model.db) - step
      end

      Sequel::Migrator.apply(Sequel::Model.db, migrations_path, version)
    end
  end

  namespace :schema do
    desc "Create a db/schema.rb file that can be portably used against any DB supported by Sequel. Types are translated to Ruby types."
    task :dump => :environment do
      Sequel.extension :schema_dumper
      File.open(ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb", "w") do |file|
        file.puts Sequel::Model.db.dump_schema_migration
      end
    end

    desc "Load a schema.rb file into the database"
    task :load => :environment do
      file = ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb"
      if File.exists?(file) then
        load(file)
      else
        abort "#{file} doesn't exist."
      end
    end
  end
end
