class MicropostsController < ApplicationController
  ##########################################################
  #验证用户是否登录
  before_action :logged_in_user,only: [:create,:destroy]

  #验证用户是否为当前用户
  before_action :correct_user, only: :destroy
  ###########################################################
  #创建微博
  def create
    #build返回一个user发布的新微博对象
    #create直接进行存储
    @micropost = current_user.microposts.build(micropost_params) 
    if @micropost.save
      flash[:success] = "内容发送成功"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home' 
    end
  end


  #删除信息
  def destroy 
    #destroy和delete都会删除数据库信息
    #destroy会调用Active Record的回调和函数验证
    #确保数据库一致性和模型业务逻辑
    @micropost.destroy
    flash[:success] = "内容删除成功"
    #重新回到之前请求的网站或者根目录
    redirect_to request.referrer || root_url
  end
############################################################
    private

      #限制微博输入参数
      def micropost_params 
      	params.require(:micropost).permit(:content)
      end


      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id]) 
        redirect_to root_url if @micropost.nil?
      end
end
