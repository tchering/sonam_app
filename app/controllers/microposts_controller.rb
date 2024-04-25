class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :index]

  def index
    redirect_to root_path
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    # In Rails, params is a method that returns a ActionController::Parameters object.                                                                                                      This object acts like a hash and contains all the form data that was sent with the request.
    # When you use a form builder like form_with and pass it a model instance (@micropost in your case),                                                                                       Rails uses the name of the model class (lowercased and underscored) as the key for the form data in the params hash.
    # So, in your case, params[:micropost] is a hash that contains all the form data for the @micropost                                                                                instance. This includes the :content and :image fields.
    # params[:micropost][:image] is accessing the uploaded image file from the form data.
    # @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
      render "static_pages/home"
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    # user in @micropost.user is the user who created the micropost or instance of User model.
    #Becuase we have defined the association in micropost.rb as belongs_to :user
    if current_user.admin? || current_user == @micropost.user
      @micropost.destroy
      flash[:success] = "Micropost deleted"
    else
      flash[:danger] = "You don't have permission to delete this micropost"
    end
    redirect_to request.referrer || root_path
  end

  private

  def micropost_params
    #here :micropost symbol corresponds to the micropost model. And the form for creating micropost
    # should have the same name as the model name and looks like this <%= form_for(@micropost) do |f| %>
    params.require(:micropost).permit(:content, :image)
    #Alos params is hash with key :micropost and value as another hash with keys :content and :image
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
