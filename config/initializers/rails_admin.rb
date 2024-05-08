RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise for all users ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Devise for all user with admin ==
  config.current_user_method { User.find_by(id: session[:user_id]) }

  config.authenticate_with do
    if _current_user.nil?
      flash[:danger] = 'You need to sign in for access to this page.'
      redirect_to main_app.login_path
    elsif !_current_user.admin?
      flash[:danger] = 'You are not authorized to access this page.'
      redirect_to main_app.root_path
    end
  end

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  ## == User model == this is to show which columns to be visible in the admin panel
  # config.model 'User' do
  #   list do
  #     field :id
  #     field :name
  #     field :email
  #     field :admin
  #     field :created_at
  #     field :updated_at
  #     field :activated
  #     field :activated_at
  #     field :profile_picture
  #   end

  # edit do
  #   field :name
  #   field :email
  #   field :password
  #   field :password_confirmation
  #   field :admin
  #   field :activated
  # end
  # end
end
