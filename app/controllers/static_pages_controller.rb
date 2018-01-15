class StaticPagesController < ApplicationController
#负责登录和退出功能

  def home
  	if logged_in?
  	  @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end
end
