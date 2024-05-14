class StaticPagesController < ApplicationController
  def home
    # @micropost = current_user.microposts.build if logged_in?
    #this above code has been modified to below code and we have also called feed method which we have defined in user.rb. This is becuase we want to show the feed of the current user in home page when user is logged in.
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
      #here we called feed method in current_user which is instance of User model therefore the feed method should be defined in User model(user.rb)
    end
  end

  def help
  end

  def blog
  end

  def about
  end

  def contact
  end
end
