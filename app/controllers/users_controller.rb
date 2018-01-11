 class UsersController < ApplicationController

  before_action :logged_in_user,only: [:edit,:update,:index,:destroy]#限制登陆用户才可使用
  before_action :correct_user,only:  [:edit,:update]#限制每个用户只能修改自己
  before_action :admin_user,only: :destroy
  #默认情况下对所有控制器动作，only用来限制,如果不注解的话访问注册页面也需要登陆，不符合逻辑

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  #存储用户
  def create
    @user = User.new(user_params) 
    if @user.save    # 将内存中的数据插入数据库，返回true和false
       @user.send_activation_email
       flash[:info] = "Please check your email to activate your email."
       redirect_to login_url
    else
        render 'new' 
    end
  end

  #在数据库查找编辑用户
  def edit
    #因为在before_action中已经完成查找和赋值，此处不再需要
    #@user = User.find(params[:id])
    #注注注意此处以ID为条件查找必须为find，不是find_by
  end

  # 更新用户
  def update
    #因为在before_action中已经完成查找和赋值，此处不再需要
    #@user = User.find(params[:id]) 
    #注注注意此处以ID为条件查找必须为find，不是find_by
    if @user.update_attributes(user_params)
       flash[:succes] = "Profile Updated!"
       redirect_to @user#是redirece_to user_url(@user)缩写，localhost:3000/users+@user
    else
      render 'edit'
    end
  end

  #删除用户
  def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
end

  #忘记用户
  def forget
    update_attribute(:remember_digest,nil)
  end  
  
  private

    #健壮参数，指定输入参数，避免批量赋值漏洞
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

   

    #确保是正确的用户
    def correct_user
      @user=User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #确保删除动作只有管理员能够执行
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
