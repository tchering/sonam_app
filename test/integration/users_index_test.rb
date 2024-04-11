require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @non_admin = users(:non_admin)
  end

  #need to test for pagination and delete when user is admin
  
end
