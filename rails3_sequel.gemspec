require 'rake'

Gem::Specification.new do |s|
  s.name = 'rails3_sequel'
  s.version = '0.3.0'
  s.date = '2010-06-13'
  s.author = 'Rachot Moragraan'
  s.email = 'janechii@gmail.com'
  s.homepage = 'http://github.com/mooman/rails3_sequel'
  s.summary = 'Rails 3 integration with Sequel'
  s.description = 'Rails 3 integration with Sequel'
  s.files = FileList['lib/**/*.rb', 'lib/**/*.rake', '[A-Z]*'].to_a
  s.has_rdoc = false

  s.add_dependency('sequel', '>= 3.11.0')
  s.add_dependency('rails', '>= 3.0.0.beta3')
end
