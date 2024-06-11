class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy index]

  def index
    redirect_to root_path
  end

  def create
    # we user build method to validate the micropost and then save it. if we use cretae method directly (current_user.microposts.create ) then it will save the micropost directly without validation.
    @micropost = current_user.microposts.build(micropost_params)
    # In Rails, params is a method that returns a ActionController::Parameters object.                                                                                  This object acts like a hash and contains all the form data that was sent with the request.
    # When you use a form builder like form_with and pass it a model instance (@micropost in your case), Rails uses
    #  the name of the model class (lowercased and underscored) as the key for the form data in the params hash.
    # So, in your case, params[:micropost] is a hash that contains all the form data for the @micropost instance.
    # This includes the :content and :image fields.
    # params[:micropost][:image] is accessing the uploaded image file from the form data.
    # @micropost.image.attach(params[:micropost][:image]) THIS LINE IS NOT REQUIRED becuase we have already strong params.
    if @micropost.save
      flash[:success] = 'Micropost created'
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
      # feed is method defined in user.rb model and is instance method of User model. Meaning here we are calling feed method on current_user which is instance of User model.That is why we are able to call feed method on current_user.
      render 'static_pages/home'
    end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])

    if @micropost.update(micropost_params)
      redirect_to root_path, notice: 'Micropost was successfully updated.'
    else
      render :edit
    end
  end
  # The destroy action is used to delete a micropost. It accepts the ID of the micropost
  # as a parameter and finds the micropost by that ID. If the current user is an admin or the owner
  # of the micropost, it deletes the micropost and sets a success message. If the user is neither
  # an admin nor the owner of the micropost, it sets a danger message. It then redirects the user to
  # the previous page they were on or the root path if they were not on a page.
  def destroy
    # Find the micropost by the ID passed in the params.
    @micropost = Micropost.find(params[:id])

    # Check if the current user is an admin or the owner of the micropost.
    if current_user.admin? || current_user == @micropost.user
      # If the user is an admin or the owner of the micropost, delete the micropost and set a success message.
      @micropost.destroy
      flash[:success] = 'Micropost deleted'
    else
      # If the user is neither an admin nor the owner of the micropost, set a danger message.
      flash[:danger] = "You don't have permission to delete this micropost"
    end
    # Redirect the user to the previous page they were on or the root path if they were not on a page.
    redirect_to request.referrer || root_path
  end

  private

  def micropost_params
    # here :micropost symbol corresponds to the micropost model. And the form for creating micropost
    # should have the same name as the model name and looks like this <%= form_for(@micropost) do |f| %>
    params.require(:micropost).permit(:content, :image)
    # Also params is hash with key :micropost and value as another hash with keys :content and :image
    # For example, when you submit the form to create a new micropost, the params hash might look something like this:
    # { "micropost" => { "content" => "Lorem ipsum", "image" => "image.jpg" } } or
    #     {
    #   :micropost => {
    #     :content => "This is my new micropost",
    #     :image => #<ActionDispatch::Http::UploadedFile:0x00007f8efc123456>
    #   }
    # }
  end
end
