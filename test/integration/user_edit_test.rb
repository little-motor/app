require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

def setup
@user = users(:michael)
end

test "unsuccessful edit" do
log_in_as(@user)
get edit_user_path(@user)
assert_template 'users/edit'
patch user_path(@user), params: { user: { name: "",
	                              email: "foo@invalid",
                                  password: "foo",
                                  password_confirmation: "bar" } }
assert_template 'users/edit' 
end

test "successful edit" do 
  log_in_as(@user)
  get edit_user_path(@user)
  assert_template 'users/edit'
  name  = "Foo Bar"
  email = "foo@bar.com"
  patch user_path(@user), params: { user: { name:  name,
  	                                        email: email,
  	                                        password: "",
  	                                        password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload #重新加载数据库中存储的值，以此确认成功更新了信息
    assert_equal name,  @user.name
    assert_equal email, @user.email
end 

test "successful edit with friendly forwarding" do 
  get edit_user_path(@user)
  log_in_as(@user)
  assert_redirected_to edit_user_url(@user)  #友好的转向
        name  = "Foo Bar"
        email = "foo@bar.com"
        patch user_path(@user), params: { user: { name:  name,
                                                  email: email } }
    assert_not flash.empty?  #登陆成功flash[:secceed]
    assert_redirected_to @user #user_url(@user)
    @user.reload #重新加载数据库
    assert_equal name,  @user.name
    assert_equal email, @user.email
end

end