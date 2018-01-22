module SessionsHelper
# 负责登录和退出功能


  def log_in(user)
    #此处的session散列方法与Sessions控制器无关
    #系统会自动在浏览器的临时cookie中存入session[:user_id]并加密
    session[:user_id] = user.id 
  end


  # 在持久cookies中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  
  # 返回当前登录的用户信息
  def current_user
    #分两种情况，第一种会话存在时，通过会话查找
    #如果session[:user_id]存在返回id值
    if(session[:user_id])
      user_id=session[:user_id]
      return @current_user ||= User.find_by(id: user_id)
    end
    #第二种会话不存在时通过永久cookies查找
    #这一步会讲加密的cookies解密
    if (user_id=cookies.signed[:user_id])
      user=User.find_by(id: user_id)
        if user && user.authenticated?(:remember,cookies[:remember_token])
          log_in user
          return @current_user=user
        else 
          return @current_user=nil
        end
    end
  end

  # 如果用户已登录，返回 true，否则返回 false 
  def logged_in?
    !current_user.nil? 
  end


  # 如果指定用户是当前用户，返回true,遵守rails的一般规定，意思更加明确
  def current_user?(user)
    user == current_user
  end


  #存储未登陆前想访问的网址
  def store_location
    #只有是GET请求时，才会存入session
    session[:forward_url] = request.original_url if request.get?
  end



  # 重定向到存储的地址或者默认地址 
  def redirect_back_to(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forwar_url) 
  end

  #忘记持久会话
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  
  #退出当前用户
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
