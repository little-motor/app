require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user=users(:michael)
    @other_user=users(:archer)
    @admin = users(:michael) 
    @non_admin = users(:archer)
  end


test "should redirect edit when not logged in" do 
  get edit_user_path(@user) #前往user/1/edit
  assert_not flash.empty?  #根据contorller前置过滤器before_action得到flash[:danger]
  assert_redirected_to login_url
end

test "should redirect update when not logged in" do
  patch user_path(@user), params: { user: { name: @user.name,
  	                                        email: @user.email
  	                                        } }
  assert_not flash.empty?
  assert_redirected_to login_url
end

test "should redirect edit when logged in as a wrong user" do
  log_in_as(@other_user)
  get edit_user_path(@user)
  assert flash.empty? #此时登陆成功，在session中登陆成功没有flash
  assert_redirected_to root_url
end
 
test "shoule redirect update when logged in as a wrong user" do
  log_in_as(@other_user)
  get edit_user_path(@user),params: { user: {name: @user.name,
                                             email: @user.email } }
  assert flash.empty?
  assert_redirected_to root_url
end

test "shoule redirect index when not logged in"do
  get users_path
  assert_redirected_to login_url
end


test "should not allow the admin attribute to be edited via the web" do 
  log_in_as(@other_user)
  assert_not @other_user.admin?
  patch user_path(@other_user), params: {
                                  user: { password:              "password",
                                          password_confirmation: "password",
                                          admin: true } }
  assert_not @other_user.admin? 
end

test "should redirect destroy when not logged in" do 
  assert_no_difference 'User.count' do
    delete user_path(@user) 
  end #确认前后人数无变化
    assert_redirected_to login_url
end

test "should redirect destroy when logged in as a non-admin" do 
  log_in_as(@other_user)
  assert_no_difference 'User.count' do
    delete user_path(@user) 
  end
  assert_redirected_to root_url
end

test "index as admin including pagination and delete links" do 
  log_in_as(@admin)
  get users_path
  assert_template 'users/index'
  
  first_page_of_users = User.paginate(page: 1) 
  first_page_of_users.each do |user|
    assert_select 'a[href=?]', user_path(user),text: user.name 
    unless user == @admin
      assert_select 'a[href=?]', user_path(user), text: 'delete' 
    end
  end
  assert_difference 'User.count', -1 do
    delete user_path(@non_admin) 
  end
end

test "index as non-admin" do 
  log_in_as(@non_admin)
  get users_path
  assert_select 'a', text: 'delete', count: 0
end



















end
