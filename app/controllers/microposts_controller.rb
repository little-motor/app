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


  def destroy 
    @micropost.destroy
    flash[:success] = "内容删除成功"
    redirect_to request.referrer || root_url
    #表示前一个URL
  end
############################################################
    private

      #限制微博输入参数
      def micropost_params 
      	params.require(:micropost).permit(:content, :picture)
      end


      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id]) 
        redirect_to root_url if @micropost.nil?
      end
end
