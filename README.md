Rails 3 Sequel integration
==========================

*What works so far:*

+ Generators
  - Models
  - Migrations
  - Observers
  - Scaffolding Controllers - Sequel specific methods

+ Rake tasks
  - mostly everything except anything that has to do with database creation (db:create, test:prepare, etc)

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
+ more rake tasks

Installation
------------

Build from the gem spec:

    gem build rails3_sequel.gemspec

Install:

    gem install rails3_sequel-x.x.x.gem

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
    config.log_warn_duration

These options may be useful in the production configuration file. Rails does not log any SQL in production mode, but you may want to still log long running queries or queries with errors (which are supported by Sequel).

Rake tasks usage.... todo

Usage - Generators
------------------

Basics:

    rails g scaffold cat name:String:pk specie:String:pk age:Integer

Will use name and specie as composite primary key.


Generator options (set in config/application.rb):

    config.generators do |g|
      g.orm :sequel, :autoincrement => true, :migration => true, :timestamps => false

The above will always generate migration files, with autoincrement/serial field named "id", but no automatic timstamp fields updated_at or created_at.

more to come...

License
-------

MIT

Credits
-------

Based partially on rails_sequel by Piotr Usewicz: http://github.com/pusewicz/rails_sequel
