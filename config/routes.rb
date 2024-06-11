Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # here for user login and logout we are using sessions controller and we are defining out custom routes for login and logout however we can use resources :sessions.Check below code for reference .
  # user login and logout routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/blog', to: 'static_pages#blog'

  # get "/show/:id", to: "users#show"
  # get "/edit/:id", to: "users#edit"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # resources :sessions, only: [:new, :create, :destroy]
  # here instead of custom routes we will use resources :sessions.Now this will create all 7 routes for sessions controller.And they are as follows but we have used only 3 routes so only 3 routes will be created.for new,create and destroy.
  #      sessions GET    /sessions(.:format)          sessions#index
  #               POST   /sessions(.:format)          sessions#create
  #   new_session GET    /sessions/new(.:format)      sessions#new
  #  edit_session GET    /sessions/:id/edit(.:format) sessions#edit
  #       session GET    /sessions/:id(.:format)      sessions#show
  #               PATCH  /sessions/:id(.:format)      sessions#update
  #               PUT    /sessions/:id(.:format)      sessions#update
  #               DELETE /sessions/:id(.:format)      sessions#destroy
  # now we also need to modify our form. For example in navbar.html.erb we have
  #  <%= link_to "Login", login_path, class: "nav-link" %> this will need to be changed to <%= link_to "new_session_path", class: "nav-link" %>
  resources :users do
    member do
      get :following, :followers
      #note that this method should be created in users_controller.rb. This method is not reference to has_many :followers or following in user.rb so can be named anything.
    end
  end

  resources :conversations do
    resources :messages
   end
  # ! This is the same as the above code but we are using resources instead of custom routes.
  # get 'users/:id/following', to: 'users#following', as: 'following_user'
  # get 'users/:id/followers', to: 'users#followers', as: 'followers_user'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts
  resources :relationships, only: %i[create destroy]
end
