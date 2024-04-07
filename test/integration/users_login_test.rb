require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  def setup
    @user = users(:one)
  end
  def is_logged_in?
    !session[:user_id].nil?
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert is_logged_in?
  end

  test "login with valid information and remember user" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['user_id']
    assert_not_empty cookies['remember_token']
  end

  # "login with valid information followed by logout" do
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # logging out
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  # test logout should delete cookies
  test "logout should delete cookies" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    assert_empty cookies['user_id']
    assert_empty cookies['remember_token']
  end

  #test login  with remember me unchecked
  test "login with remember me unchecked" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['user_id']
    assert_empty cookies['remember_token']
  end

  #test login with remember me checked
  test "login with remember me checked" do
    log_in_as(@user, remember_me: '0')
    delete logout_path
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['user_id']
    assert_not_empty cookies['remember_token']
  end



  private

  # Log in as a particular user.
  def log_in_as(user, remember_me: '0')
    post login_path, params: { session: { email: user.email,
                                          password: 'password',
                                          remember_me: remember_me } }
  end


end
