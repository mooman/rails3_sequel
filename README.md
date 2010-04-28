Rails 3 Sequel integration
==========================

Based partially on rails_sequel by Piotr Usewicz: http://github.com/pusewicz/rails_sequel

*What (kindda) works so far:*

+ Generators
  - Models
  - Migrations
  - Observers

+ Rake tasks
  - mostly everything except anything that has to do with database creation (db:create, test:prepare, etc)

+ Railties
  - database.yml configuration
  - db connection
  - query logging
  - controller logging (with crude timing)
  - sane default sequel options and plugins for Rails

*What is still need done:*

+ Testing
  - haven't really tested much

+ i18n
+ Session
+ User define options
+ Gem
+ more rake tasks

Usage
-----

For now, please put this in vendor/plugins path and include (absolute filename) the railtie.rb in your environment. In the future, i will make a gem. 

Then you can use as you would with ActiveRecord, but please note that this still needs a lot of work.

License
-------

MIT
