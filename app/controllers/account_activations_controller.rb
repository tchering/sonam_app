class AccountActivationsController < ApplicationController
  #NOTE:<%= link_to "Activate account", edit_account_activation_url(@user.activation_token, email: @user.email) %> This is in account_activation.html.erb
  #so when user clicks on this link, it will send a get request to this edit action

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate #now we need to create this method in user.rb instead of directly updating the attributes like below
      # user.update_attribute(:activated, true)
      # user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Your account has been activated"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_path
    end
  end
end
