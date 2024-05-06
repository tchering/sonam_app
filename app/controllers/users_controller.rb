class UsersController < ApplicationController
  # before filters
  before_action :logged_in_user, only: %i[edit update show index destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: %i[show edit update destroy]

  def index
    @users = if params[:search].present?
               User.where('name LIKE ? AND activated = ?', "%#{params[:search]}%", true).paginate(page: params[:page],
                                                                                                  per_page: 6)
             else
               User.where(activated: true).paginate(page: params[:page], per_page: 6)
             end
  end

  def new
    @user = User.new
  end

  def show
    # this is commented because we are using before_action to find user
    # @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 8)
  end

  def destroy
    # User.find(params[:id]).destroy
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
  end

  # this will show the form to update user
  def edit
    # @user = User.find(params[:id])
  end

  # this will actually update the user
  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      # Handle a successful update.
      flash[:success] = 'Profile updated'
      redirect_to user_path
    else
      puts @user.errors.full_messages
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      # or we will create method in user.rb to send activation email and call it here as below
      @user.send_activation_email
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      flash[:info] = 'We have sent you an Email. Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  # methods fowwowing and followers are defined here. Becuase we have created routes for them in routes.rb
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], per_page: 6)
    render 'show_follow'
    # since we have rendered 'show_follow' so we need to create a view(not partial) with name show_follow.html.erb in views/users folder
    # remember if we need to render a partial we use <%=render 'show_follow %> and in we name the file as _show_follow.html.erb
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 6)
    render 'show_follow'
    # since we have rendered 'show_follow' so we need to create a view(not partial) with name show_follow.html.erb in views/users folder
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_picture)
  end

  # becuase now microposts_controller and users_controller both are using this method so its better to keep code dry.

  # def logged_in_user
  #   unless logged_in?
  #     #logged_in? is a helper method in app/helpers/sessions_helper.rb
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   end
  # end

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
