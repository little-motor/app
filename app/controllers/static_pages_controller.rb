class StaticPagesController < ApplicationController
#负责home页面

  def home
  	if logged_in?
  	  @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

end
