class AccountActivationsController < ApplicationController
	def edit
	  user = User.find_by(email: params[:email])
      if user && !user.activated? && user.authenticated?(:activation,params[:id])
      #用户存在 且 用户未激活（防止黑客利用令牌登入已激活的账号 且 用户验证通过
        user.activate
        log_in user
        flash[:success] = "Account activated!"
        redirect_to user
      else
      	flash[:danger] = "Invalid activation link"
      	redirect_to root_url
      end
  end
end
