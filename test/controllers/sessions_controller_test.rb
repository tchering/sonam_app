require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should get create" do
    post login_path, params: { session: { email: "test@example.com", password: "password" } }
    assert_response :success
  end



  test "should redirect to user path after successful login and if is activated" do
    @user.update_attribute(:activated, true)
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to user_path(@user)
  end

  # Rest of the tests...
end
