source "http://rubygems.org"

gem "rails"

#gem "pg", :require => "pg"
gem "mysql2"
gem "activerecord-mysql-adapter"

gem "paperclip", "~> 3.0"
gem "carrierwave"
#Paperclip and mini_magic is only necessary
gem "rmagick", "~> 2.13.2"

gem "jquery-rails"
gem "devise"
gem 'devise_invitable'
gem "omniauth-facebook"
gem "omniauth-linkedin"
gem "kaminari"
gem "meta_search"
gem "simple_form"
gem "dynamic_form"
gem 'client_side_validations'
gem "heroku"
gem "coffee-rails"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'omniauth-twitter'
gem 'twitter'
gem 'acts_as_commentable'
gem 'aws-sdk'
gem "acts_as_paranoid", "~>0.4.0"
gem "friendly_id"
gem "nested_form"
gem "paper_trail"
gem 'public_activity'
gem 'arel' #Complex SQL queries
gem 'sitemap'
gem "sidekiq"
gem "redis"
gem 'mandrill-api'
gem 'thumbs_up'

gem "rails-settings-cached", "0.2.4"

group :assets do
  gem "therubyracer", :platform => :ruby
end

group :test, :development do
  gem "rspec-rails"
  gem "spork-rails"
  gem "debugger"
  gem "awesome_print"
end

group :development do
  gem "chronic"
  gem "admin_view"
  gem 'heroku_san'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'pry'
  gem 'rack-mini-profiler'
  gem 'zeus'
  gem 'spring'
end

group :test do
  gem "factory_girl_rails"
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "capybara"
  gem "shoulda"
  gem "email_spec"
  gem "capybara-webkit"
  gem "launchy"
  gem "webmock"
  gem 'simplecov', :require => false
end

group :production, :development do
  gem "thin"
  gem 'newrelic_rpm'
end

gem "airbrake"
gem "surveyor"
gem 'rack-rewrite'

gem "activemerchant"
