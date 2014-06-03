require 'simplecov'
SimpleCov.start 'rails'
require 'rubygems'
require 'spork'
require 'paperclip/matchers'

Spork.prefork do

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require "email_spec"
  require 'webmock/rspec'
  require 'rake'

  WebMock.disable_net_connect!(:allow_localhost => true)

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  #Update this call to populate database
  system "bundle exec rake db:test:prepare"
  system "bundle exec rake surveyor FILE=surveys/get_viable_questions_leslie_v3-2-2.rb"
  system "bundle exec rake db:seed RAILS_ENV=test"

  RSpec.configure do |config|
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.include Devise::TestHelpers, :type => :controller

    config.extend ControllerMacros, :type => :controller
    config.extend RequestMacros, :type => :request

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    config.mock_with :rspec

    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    config.include FactoryGirl::Syntax::Methods
    config.include Paperclip::Shoulda::Matchers

    #DatabaseCleaner.strategy = :transaction
    #DatabaseCleaner.clean_with(:truncation)
       #DatabaseCleaner.strategy = :truncation, {:except => %w[table1 table2]}
    config.before :each do
      if Capybara.current_driver == :rack_test
        DatabaseCleaner.strategy = :truncation, {:except => %w[surveys survey_sections dependencies dependency_conditions questions question_groups answers validations validation_conditions stages]}
      else
        DatabaseCleaner.strategy = :truncation, {:except => %w[surveys survey_sections dependencies dependency_conditions questions question_groups answers validations validation_conditions stages]}
      end
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end
  end

end

Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  FactoryGirl.reload
end
