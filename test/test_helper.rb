ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    #This helper was originally in test/integration/users_login_test.rb
    # Returns true if a test user is logged in.
    def log_in_as(user, remember_me: '0')
      post login_path, params: { session: { email: user.email,
                                            password: 'password',
                                            remember_me: remember_me } }
    end
  end
end
