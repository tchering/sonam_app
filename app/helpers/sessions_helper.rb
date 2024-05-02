module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # helper method that returns the current logged-in user (if any)
  # def current_user
  #   if session[:user_id]
  #     # technique called memoization. It's a way to cache the result of an expensive operation (in this case, a database query) to improve performance.
  #     @current_user = @current_user || User.find_by(id: session[:user_id])
  #   end
  # end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id]) # if session has user_id then assign it to user_id
      @current_user ||= User.find_by(id: user_id) # and finds that user by user_id in database and assigns it to @current_user
    elsif (user_id = cookies.encrypted[:user_id]) # if session doesnt have user_id then check if cookies has user_id
      user = User.find_by(id: user_id) # if cookies has user_id then find that user by user_id in database and assigns it to user
      if user && user.authenticated?(:remember, cookies[:remember_token]) # if user is found in db and authenticated which is in user.rb
        #  then log_in that user and assign it to @current_user
        log_in user
        @current_user = user
      end
    end
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember # here remember is a method defined in user.rb and this method we will call in create in sessions_controllere
    # now logged in user id will be stored in cookies
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # same for remember method aswell.
  def forget(user) # this method will be called in sessions_controller.rb and the @user object will be passed in user argument.
    user.forget # this method is defined in user.rb
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
end
