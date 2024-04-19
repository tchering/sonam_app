class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest  #this method is defined in user.rb
      @user.send_password_reset_email #this method is defined in user.rb
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new"
    end
  end

  def edit
  end

  def update
    #here we dont need to find user and authenticate it again as we have done it in before_action

    # In Ruby on Rails, when you submit a form that was created with a model object (like form_with(model: @user)), the parameters are nested under the model name. This is why you see params[:user][:password]
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit"
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    puts "User: #{@user.inspect}"
    puts "Activated: #{@user.activated?}" if @user
    puts "Authenticated: #{@user.authenticated?(:reset, params[:id])}" if @user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      flash[:info] = "Your account is not activated"
      redirect_to root_path
    end
  end

  def check_expiration
    #here we call password_reset_expired? method so need to define it in user.rb
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
