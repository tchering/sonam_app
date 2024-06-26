
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @other_user = users(:two)  # replace :one with the fixture key for your user
  end
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in " do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: { password: "password",
              password_confirmation: "password",
              admin: true }
    }
    assert_not @other_user.reload.admin?
  end

  test "should be able to upload profile picture" do
    log_in_as(@user)
    picture = fixture_file_upload('test_image.png', 'image/png')
    patch user_path(@user), params: {
      user: { profile_picture: picture,
              password: "Password1",
              password_confirmation: "Password1" }
    }
    assert_redirected_to @user
    @user.reload
    assert @user.profile_picture.attached?
  end

end
