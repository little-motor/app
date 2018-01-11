require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } } 
    assert_template 'sessions/new'
    assert_not flash.empty?
    get signup_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do #测试退出功能
  	get login_path
    post login_path, params: { session: { email:    @user.email,
                                              password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
	follow_redirect!        # 跟踪重定向，渲染 users/show 模板
	assert_template 'users/show' #渲染模板
	assert_select "a[href=?]", login_path, count: 0  
	#count: 0参数的目的是告诉assert_select，我们期望页面中有零个匹配指定模式的链接
	assert_select "a[href=?]", logout_path
	assert_select "a[href=?]", user_path(@user)
	delete logout_path
	assert_not is_logged_in?
	assert_redirected_to root_url
  delete logout_path #模拟用户在另一个窗口中点击推出链接
	follow_redirect!
	assert_select "a[href=?]", login_path
	assert_select "a[href=?]", logout_path, count: 0
	assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do 
    log_in_as(@user, remember_me: '1') 
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do 
    # 登录，设定 cookie 
    log_in_as(@user, remember_me: '1') 
    delete logout_path
    # 再次登录，确认 cookie 被删除了 
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end


end
