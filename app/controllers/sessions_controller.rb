class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # authenticate method is automatically added by has_secure_password method in user.rb model.
    if user&.authenticate(params[:session][:password]) # safe navigation operator
      if user.activated?
        log_in user
        # add this remember method to for checking remember me checkbox
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # add this to fix logout bug
    log_out if logged_in?
    flash[:success] = 'You have successfully logged out'
    redirect_to root_path
  end
end
