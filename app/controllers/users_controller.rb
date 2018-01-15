 class UsersController < ApplicationController
  #负责用户的登录和状态

  #only用于限制特定的动作
  #before_action前置过滤器，制定某个动作运行前先执行的方法

  ###################################################################
  #限制登陆用户才可使用的几个动作
  before_action :logged_in_user,  #位于application_controller
                                  only: [:edit,:update,:index,:destroy]
  #限制每个用户只能修改自己
  before_action :correct_user,  #位于session_helper
                                  only:  [:edit,:update]
  #限制只有管理员才能进行删除
  before_action :admin_user,  # 位于最下面
                                  only: :destroy
  ###################################################################

  #用于新建用户，填写注册信息时使用，对应GET
  def new
    @user = User.new
  end

  #用于新建用户，处理提交的信息写入数据库，对应POST
  def create
    #user_params健壮参数，指定输入参数，避免批量赋值漏洞
    #params.require(:user).permit(:name, :email, :password,
    #                             :password_confirmation)
    @user = User.new(user_params) 
    # 将内存中的数据插入数据库，返回true和false
    if @user.save    
      # @user.send_activation_email
      # flash[:info] = "Please check your email to activate your email."
      #在用redirect_to时需要用*_url这样的绝对路径。
       redirect_to login_url
    else
        render 'new' 
    end
  end


  #展示所有用户
  #加入行分页功能
  def index
     @users = User.paginate(page: params[:page])
  end


  #显示特定id的用户，用户浏览某个具体用户时使用
  def show
    @user = User.find(params[:id])
    #用到分页paginate gem，默认30页
    #paginate 方法所需的 :page 参数由 params[:page] 指定
    @microposts = @user.microposts.paginate(page: params[:page])
  end


  #在数据库查找编辑和更新用户
  def edit
    #因为在before_action中的curroct_user已经完成查找和赋值，此处不再需要
    #@user = User.find(params[:id])
    #注注注意此处以ID为条件查找必须为find，不是find_by
  end


  # 更新用户，对应Patch动作
  def update
    #因为在before_action中已经完成查找和赋值，此处不再需要
    #@user = User.find(params[:id]) 
    #注注注意此处以ID为条件查找必须为find，不是find_by
    #update_attributes接受指定对象的属性散列作为参数，修改成为返回true
    if @user.update_attributes(user_params)
       flash[:succes] = "Profile Updated!"
       #redirect_to执行动作，转向新的页面，render用于本页的渲染
       #指向show
       redirect_to user_url(@user)
    else
      #本页渲染
      render 'edit'
    end
  end

  #忘记密码，暂时不用后续开发
  # def forget
  #   update_attribute(:remember_digest,nil)
  # end 


  #删除用户
  #位于_user页面
  def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
end

  ###################################################################
  #私有函数，封装特定的函数，只能在该模块中使用，提高安全性和模块的独立性。
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
