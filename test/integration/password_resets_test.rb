require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:one) # replace :one with the fixture name of your user
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"
    # Valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                   user: { password: "foobazqsdDf1.",
                           password_confirmation: "barquuxqsdfqD1." } }
    assert_select "div#error_explanation"
    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                   user: { password: "",
                           password_confirmation: "" } }
    assert_select "div#error_explanation"
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                   user: { password: "foobazdD1",
                           password_confirmation: "foobazdD1" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end

test "expired token" do
    # Request password reset
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest

    # Get user from assigns, which contains the @user instance variable from the controller
    user = assigns(:user)

    # Try to reset password with expired token
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_equal "Password reset has expired.", flash[:danger]
  end
end
