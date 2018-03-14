if ENV['RAILS_ENV'] == 'test' and not ENV['NO_COVERAGE']
  require 'simplecov'
  SimpleCov.start :rails do
    coverage_dir 'tmp/coverage'
    add_filter ['app/channels/', 'app/jobs', 'app/mailers/']
  end
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  # FactoryBot instead of fixtures
  include FactoryBot::Syntax::Methods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  # Add more helper methods to be used by all tests here...

  def is_logged_in?
    not session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_url, params: { session: { email: user.email,
                                         password: password } }
  end
end

module GiverTakerInterface
  def test_implements_the_trader_interface
    assert_respond_to @object, :give
    assert_respond_to @object, :take
  end
end

module ApplierInterface
  def test_implements_the_applier_interface
    assert_respond_to @object.class, :apply
    assert_respond_to @object, :trade
  end
end
