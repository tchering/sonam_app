class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @non_admin = users(:non_admin)
    @admin.update_attribute(:activated,true)
    @non_admin.update_attribute(:activated,true)
  end

  def log_in_as(user, remember_me: '0')
    post login_path, params: { session: { email: user.email,
                                          password: 'password',
                                          remember_me: remember_me } }
  end

  test "index page should display all users" do
    log_in_as(@admin)
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "admin can see delete link and delete other users" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    User.paginate(page: 1).each do |user|
      unless user == @admin
        assert_select 'a[href=?][data-method="delete"]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "non-admin user cannot see delete link" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "admin cannot see delete link for himself" do
    log_in_as(@admin)
    get users_path
    assert_select 'a[href=?]', user_path(@admin), text: 'delete', count: 0
  end
end
