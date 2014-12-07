$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'dateslices/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'dateslices'
  s.version     = Dateslices::VERSION
  s.authors     = ['Will Schenk']
  s.email       = ['will@happyfuncorp.com']
  s.homepage    = 'https://github.com/sublimeguile/dateslices'
  s.summary     = 'A Rails 4 ActiveRecord plugin that adds group_by_day, group_by_month, etc.'
  s.description = 'A Rails 4 ActiveRecord plugin that adds group_by_day, group_by_month, etc. Not timezone aware, but supports sqlite.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-autotest'
  s.add_development_dependency 'autotest-rails'
end
