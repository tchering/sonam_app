require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @non_admin = users(:non_admin)
  end

  test "admin can see delete link and delete other users" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "a[href=?][data-turbo-method='delete']", user_path(@non_admin)
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
    follow_redirect!
    assert_template "users/index"
    assert_select "a[href=?]", user_path(@non_admin), count: 0
  end

  test "admin cannot see delete link for himself" do
    log_in_as(@admin)
    get users_path
    assert_template "users/index"
    assert_select "a[href=?][data-turbo-method='delete']", user_path(@admin), count: 0
  end

  test "non-admin user cannot see delete link" do
    log_in_as(@non_admin)
    get users_path
    assert_template "users/index"
    assert_select "a[href=?][data-turbo-method='delete']", user_path(@non_admin), count: 0
  end

  test "index page should display all users" do
    log_in_as(@non_admin)
    get users_path
    assert_template "users/index"
    assert_select "title", "All users | Ruby on Rails Tutorial"
    assert_select "h2", "All Users"
    assert_select "div.pagination"
  end
end
