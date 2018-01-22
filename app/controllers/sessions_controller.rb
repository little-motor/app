class SessionsController < ApplicationController
  #负责用户的登录以及cookies

  
  #用户登录界面控制器，用于填写账户和密码
  def new
  end


  # 登入用户，产生session会话
  def create 
    #登录表单向session提交信息，于是有params[:session]散列
    user = User.find_by(email: params[:session][:email].downcase)
    #在user模型中has_secure_password方法里面的authenticate
    #用于验证数据库中的password_digest
    #验证用户存在性和密码正确性
    if user && user.authenticate(params[:session][:password])
      #验证用户激活状态
      #activated为users表字段，默认false
      if user.activated?
        #将user存入session方法中
        log_in user
        #根据记住我选项的值确认是否记住登陆用户
        params[:session][:remember_me] == '1' ? 
                      remember(user) : forget(user)
        #redirect_back_to用于缓存为登入时的路径，人性化设计
        redirect_back_to user_url(user)
      else
        message = "账户未激活，强检查您的邮件"
        flash[:warning] = message
        redirect_to login_path
      end
    else
      flash.now[:danger] = '无效的账户或者密码'
      render 'new' 
    end
  end
  
  #退出账户
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end


end
