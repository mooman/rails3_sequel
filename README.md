Rails 3 Sequel integration
==========================

Features:

+ Generators
  - Models - models and migrations
  - Migrations - for table alters
  - Scaffold
    - Controller uses Sequel specific methods.
    - Views recognize migration data types.

+ Rake tasks
  - mostly everything except db:test:prepare, db:setup, and db:create:all (should be ready next version)

+ Railties
  - uses database.yml configuration
  - db connection
  - query logging
  - controller logging
  - sane default sequel options and plugins for Rails

+ Gemspec

*What is still need done:*

+ More testing
+ i18n
+ Session Store
+ Observers
+ more rake tasks
+ adapter specific after_create proc

Installation
------------

    gem install rails3_sequel

OR, in your Gemfile

    gem 'rails3_sequel'

then run bundle install.

Usage - Railties
----------------

In your config/application.rb, take out the require "all" line and choose what frameworks you want to include like this:

    require "action_controller/railtie"
    require "action_mailer/railtie"
    require "active_resource/railtie"
    require "rails/test_unit/railtie"

    # most importantly :)
    require 'rails3_sequel/railtie'

This way Rails wont load activerecord.

Config options:

    # set false to turn off Rails SQL logging
    # true by default
    config.rails_fancy_pants_logging = false

    # specify your own loggers
    config.loggers << Logger.new('test.log')

    # shortcut to log_warn_duration in Sequel
    # you can also set this option in database.yml
    config.log_warn_duration

These options may be useful in the production configuration file. Rails does not log any SQL in production mode, but you may want to still log long running queries or queries with errors (which are supported by Sequel).

Rake tasks usage:

    db:create
      Creates the database defined in your Rails environment. Unlike AR, this does not create test database with your development. You must specify your Rails environment manually.
      ex. RAILS_ENV=test rake db:create
    db:migrate
      You know what this does.
    db:migrate:up
      Alias to db:migrate.
    db:migrate:down
      Define either VERSION or STEP. VERSION takes precedence if both are defined. STEP=1 if neither are defined.
    db:migrate:redo
      Migrates down 1 version, then runs db:migrate.
    db:migrate:rollback
      Alias to db:migrate:down. Can use VERSION and STEP also.
    db:schema:dump
      Uses Sequel's schema_dumper. Stores output in db/schema.rb.
    db:schema:load
      Does not work yet, but you can use just run the migrator on the schema file.
    db:seed
      Load the seed data from db/seeds.rb
    db:version
      Shows the current migration version
    db:setup, db:test:load, db:test:purge
      Not implemented yet

Please note that db:create currently only works with PostgreSQL, MySQL, and SQLite. If you have other DBs, please contribute if you can!


Usage - Generators
------------------

Basics:

    rails g [scaffold, model, migration] <name> <field_name:data_type[:primary_key?]> [...]

Example:

    rails g scaffold cat name:String:pk specie:String:pk age:Integer

Will use name and specie as composite primary keys. Data types are as specified in Sequel's documentation, which means if you use Ruby's classes, Sequel will try to convert it for your particular database, otherwise, it will take the type as is. With that said, there are 2 special types that are not Ruby classes (mainly to help out with view scaffolding):
    
    Boolean - will use a TrueClass in your migration and a checkbox in your view.
    Text    - will use a String with the :text option set to true and a text_area in your view.

Example:

   rails g scaffold cat name:String:pk description:Text ugly:Boolean location:geocode

Note that the "location" field's type will not be translated and geocode will be used as the type in the database.


Generator options (set in config/application.rb for defaults):

    config.generators do |g|
      g.orm :sequel, :autoincrement => true, :migration => true, :timestamps => false
      ...
    end

The above will always generate migration files, with autoincrement/serial field named "id", but no automatic timstamp fields updated_at or created_at. Defaults are :autoincrement => false, :migration => :true, :timestamps => false. In the commandline, you can override these on a case-by-case basis.

Example:
    
    rails g model dog name:String specie:String --autoincrement


BUGS / ISSUES / QUESTIONS
-------------------------

Please feel free to email me with any issues or message me on github. janechii at gmail.


License
-------

MIT

Credits
-------

Based partially on rails_sequel by Piotr Usewicz: http://github.com/pusewicz/rails_sequel
Thanks to ActiveRecord's and dm-rails' railties
