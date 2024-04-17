class UsersController < ApplicationController
  #before filters
  before_action :logged_in_user, only: [:edit, :update, :show, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 3)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to user_path
    else
      puts @user.errors.full_messages
      render "edit"
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      #or we will create method in user.rb to send activation email and call it here as below
      @user.send_activation_email
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      flash[:info] = "We have sent you an Email. Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      #logged_in? is a helper method in app/helpers/sessions_helper.rb
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
