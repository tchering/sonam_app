require "test_helper"
class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
    @user = users(:one) # assuming :one is a valid user
    @micropost.image.attach(io: File.open("test/fixtures/files/test_image.png"), filename: "test_image.png", content_type: "image/png")
  end

  test "user should be redirected to login page when trying to create a micropost while not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should create a micropost when logged in" do
    log_in_as(users(:one))
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to root_url
    assert_equal "Micropost created", flash[:success]
  end

  test "should not create a micropost with invalid content" do
    @user = users(:one) # ensure :one is a valid user
    log_in_as(@user)
    assert_no_difference "Micropost.count" do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_template "static_pages/home"
    assert_not assigns(:feed_items).empty? # expect @feed_items to be non-empty
  end

  test "should destroy a micropost when logged in as admin" do
    log_in_as(users(:one)) # ensure :admin is an admin user
    @micropost = microposts(:orange) # ensure :orange is a valid micropost
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
    assert_equal "Micropost deleted", flash[:success]
  end

  test "should destroy a micropost when logged in as the owner" do
    log_in_as(users(:one))
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
    assert_equal "Micropost deleted", flash[:success]
  end

  test "should not destroy a micropost when logged in as a non-admin and non-owner user" do
    log_in_as(users(:two)) # assuming :two is a non-admin and non-owner user
    @micropost = microposts(:orange) # get a micropost that belongs to users(:two)
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url # expect redirect to root_url
    follow_redirect!
    assert_not flash.empty?
  end

  test "micropost interface with pagination" do
    log_in_as(@user)
    get root_path
    assert_select "div.pagination"
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test "should create micropost with image" do
    log_in_as(@user)
    image = fixture_file_upload("test/fixtures/files/test_image.png", "image/jpeg")
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: { micropost: { content: "Lorem ipsum", image: image } }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_select "div.alert-success", text: "Micropost created"
  end
end
