class RelationshipsController < ApplicationController
  before_action :logged_in_user

  # This method is called when the user clicks the "Follow" button
  # on the user's profile page. It creates a new relationship
  # between the current user and the user whose profile they are
  # viewing.
  def create
    # Find the user whose profile the user is viewing.
    @user = User.find(params[:followed_id])

    # Call the `follow` method on the current user, passing in the
    # user whose profile they are viewing. This method is defined in
    # the User model.
    current_user.follow(@user)

    # Respond to the request with different content depending on
    # whether the request is HTML or JS. If the request is HTML,
    # redirect the user to the user's profile page. If the request
    # is JS, render the `create.js.erb` template.
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed_id
    current_user.unfollow(@user)
    # redirect_to user_path(@user)
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
  end
end
