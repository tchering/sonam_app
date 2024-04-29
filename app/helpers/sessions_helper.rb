module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  #1 if (user_id = session[:user_id]): This line is checking if there's a user id stored in the session. If there is, it assigns that id to the local variable user_id. If session[:user_id] is not nil, this if condition will be true, and the method will return nil because there's no code inside this if block.

  #2 elsif (user_id = cookies.encrypted[:user_id]): If there was no user id in the session, this line checks if there's a user id stored in the encrypted cookies. If there is, it assigns that id to the local variable user_id.

  #3 user = User.find_by(id: user_id): This line tries to find a user in the database with the id that was retrieved from the encrypted cookies.

  # if user && user.authenticated?(cookies[:remember_token]): This line checks two things: first, if a user was found in the database, and second, if the found user's authenticated? method returns true when passed the remember token from the cookies.

  #4 log_in user: If the above condition was true, this line logs in the user by calling the log_in method with the found user.

  #5 @current_user = user: This line sets the @current_user instance variable to the found user. This is typically used to cache the current user, so you don't have to look them up in the database again during the same request.
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

    # Remembers a user in a persistent session.
    def remember(user)
      user.remember
      cookies.permanent.encrypted[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

#same for remember method aswell.
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
