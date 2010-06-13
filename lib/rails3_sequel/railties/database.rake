# dont spit out SELECT messages
# maybe there's a better way to do this?
class PickyLogger < Logger
  def add (severity, message = nil, progname = nil, &block)
    # using progname because that's where the levels put the message
    return if progname =~ /SELECT/
    super
  end
end

namespace :db do
  def migrations_path
    File.join(RAILS_ROOT, 'db', 'migrate')
  end

  desc 'Create the database, load the schema, and initialize with the seed data'
  task :setup => ['db:create', 'db:schema:load', 'db:seed']

  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  namespace :create do
    task :all => :environment do
      Rails::Sequel::Database.create_all
    end
  end
  
  desc 'Creates the database defined in your Rails environment. Unlike AR, this does not create test database with your development. You must specify your Rails environment manually.'
  task :create, :env, :needs => :environment do |t, args|
    args.with_defaults(:env => Rails.env)
    Rails::Sequel::Database.create_database(args.env)
  end

  namespace :drop do
    task :all => :environment do
      Rails::Sequel::Database.drop_all
    end
  end

  desc 'Opposite of db:create'
  task :drop, :env, :needs => :environment do |t, args|
    args.with_defaults(:env => Rails.env)
    # TODO: what happens if database doesn't exist?
    Rails::Sequel::Database.drop_database(args.env)
  end

  namespace :migrate do
    task :sequel_migration => :environment do
      Sequel.extension :migration
      # outputs statements to screen also
      Sequel::Model.db.loggers << PickyLogger.new(STDOUT)
    end

    desc 'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x.'
    task :redo => [ 'db:migrate:down', 'db:migrate' ]

    desc 'Migrate up. Alias to db:migrate.'
    task :up => 'db:migrate'

    desc 'Migrate down. Define either VERSION or STEP. VERSION takes precedence if both are defined. STEP=1 if neither are defined'
    task :down, :needs => :sequel_migration do
      if ENV['VERSION'] then
        version = ENV['VERSION'].to_i
      else
        step = ENV['STEP'] ? ENV['STEP'].to_i : 1
        version = Sequel::Migrator.get_current_migration_version(Sequel::Model.db) - step
      end

      Sequel::Migrator.apply(Sequel::Model.db, migrations_path, version)
    end
  end

  desc "Retrieves the current schema version number."
  task :version, :needs => 'migrate:sequel_migration' do
    puts "Current version: #{Sequel::Migrator.get_current_migration_version(Sequel::Model.db)}"
  end
  
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x."
  task :migrate, :needs => 'migrate:sequel_migration' do
    if ENV['VERSION']
      Sequel::Migrator.apply(Sequel::Model.db, migrations_path, ENV['VERSION'].to_i)
    else
      Sequel::Migrator.apply(Sequel::Model.db, migrations_path)
    end
  end

  desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n. This is an alias to db:migrate:down.'
  task :rollback => 'db:migrate:down'


  namespace :schema do
    desc "Create a db/schema.rb file that can be portably used against any DB supported by Sequel."
    task :dump => :environment do
      Sequel.extension :schema_dumper
      File.open(ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb", "w") do |file|
        file.puts Sequel::Model.db.dump_schema_migration
      end

      # TODO: needs also away to store current schema version
    end

    desc "Load a schema.rb file into the database."
    task :load, :db, :needs => :environment do |t, args|
      args.with_defaults(:db => Sequel::Model.db)

      file = ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb"
      if File.exists?(file) then
        Sequel.extension :migration
        schema_migration = eval(File.read(file))
        schema_migration.apply(args.db, :up)
      else
        abort "#{file} doesn't exist."
      end
    end
  end

  namespace :test do
    desc "Recreate the test database from the current schema.rb"
    task :load => 'db:test:purge' do
      db = Rails::Sequel::Database.connect('test')
      Rake::Task['db:schema:load'].invoke(db)
    end

    desc 'Runs db:test:load'
    task :prepare => :load

    desc 'Empty the test database'
    task :purge => :environment do
      Rake::Task['db:drop'].invoke('test')
      Rake::Task['db:create'].invoke('test')
    end
  end

end

task 'test:prepare' => 'db:test:prepare'
