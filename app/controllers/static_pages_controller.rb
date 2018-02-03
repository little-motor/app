class StaticPagesController < ApplicationController
#负责home页面


  #登录时在home页面显示信息发送和已发表的信息
  def home
  	if logged_in?
  	  @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end


  def upload
  end
end
