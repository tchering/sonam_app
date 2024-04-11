require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user2 = users(:two)
  end

  test "should get edit" do
    user = users(:one)
    log_in_as(user)
    get edit_user_path(user)
    assert_response :success
    assert_template "users/edit"
  end

  test "should update user with valid data" do
    user = users(:one)
    log_in_as(user)
    patch user_path(user), params: { user: { name: "New Name", email: "new@example.com", password: "" } }
    assert_redirected_to user_path(user)
    user.reload
    assert_equal "New Name", user.name
    assert_equal "new@example.com", user.email
    assert_equal "Profile updated", flash[:success]
  end

  test "should not update user with invalid data" do
    user = users(:one)
    log_in_as(user)
    patch user_path(user), params: { user: { name: "", email: "invalid_email", password: "InvalidPassword1" } }
    assert_template "users/edit"
    user.reload
    assert_not_equal "", user.name
    assert_not_equal "invalid_email", user.email
  end

  test "should redirect user to login page if he tries to edit without being logged in" do
    get edit_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect user to login page if he tries to update without being logged in" do
    patch user_path(@user), params: { user: { name: "New Name", email: "new@example.com", password: "" } }
    assert_redirected_to login_url
  end

  #users should not be able to edit other users' profiles
  test "should redirect user to root_url if he tries to edit another user's profile" do
    log_in_as(@user2)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  # Users should not be able to update other users' profiles
test "should redirect update when logged in as wrong user" do
  log_in_as(@user2)
  patch user_path(@user), params: { user: { name: "New Name", email: "new@example.com" } }
  assert flash.empty?
  assert_redirected_to root_url
end


end
