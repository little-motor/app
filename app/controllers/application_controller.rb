class ApplicationController < ActionController::Base
	
  #阻止CSRF攻击
  protect_from_forgery with: :exception

  #导入SessionHelper的动作
  include SessionsHelper

  ######################################################################
    private
      # 确保用户已登录 
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in." 
          redirect_to login_url
        end 
      end
    end
