# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start
#$LOAD_PATH.unshift(File.dirname( __FILE__, 'lib/rubyttt/lib/ttt' ))
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'ruby-ttt/lib/ttt/game'
require 'ruby-ttt/lib/ttt/three_by_three'
require 'ruby-ttt/lib/ttt/four_by_four'
require 'ruby-ttt/lib/ttt/three_by_three_by_three'
require 'ruby-ttt/lib/ttt/human'
require 'ruby-ttt/lib/ttt/ai_easy'
require 'ruby-ttt/lib/ttt/ai_medium'
require 'ruby-ttt/lib/ttt/ai_hard'
require 'ruby-ttt/lib/ttt/web_view'
require 'ruby-ttt/lib/ttt/game_setup'
require 'ruby-ttt/lib/ttt/game_setup_io_interface'
require 'ruby-ttt/lib/ttt/gameio'
require 'ruby-ttt/lib/ttt/board'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end
