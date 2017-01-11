Rails.application.routes.draw do

  resources :organizations do 
    member do 
      post 'email_members_upload_file'
      post 'import_members_upload_file'
      post 'add_individual'
      get  'test'
      get  'download_csv_template'
    end
  end

  # use routes error to handle both member and collection routes when exception is thrown
  resources :errors, only: [:user_error, :application_error, :not_found, :internal_server_error] do
     member do
      get 'user_error'
     end

     collection do
      get 'user_error'
     end
  end

  # exceptions and errors handling for application
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/apperror", :to => "errors#application_error", :via => :all 

  root 'pages#index'

  get '/profile/verify-current-password' => 'profiles#verify_current_password'
  patch '/profile/update-password' => 'profiles#update_password'
  get 'profile' => 'profiles#show', as: 'member_profile'

  get 'domino-team' => 'pages#team'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'faq' => 'pages#faq'
  get 'example' => 'pages#example'
  get 'partners' => 'pages#partners'
  get '/welcome-email/:profile_id' => 'profiles#welcome_email'
  get '/legacy-user-registration-email/:lu_id' => 'profiles#lu_registration_email'
  get "/dashboard/:slug" => redirect{ |params, req| "users/sign_up?#{req.params.to_query}" }

  get "/continue/:profile_id" => 'pages#index'

  get "/newsletter-subscribe" => 'pages#newsletter_subscribe'
  
  get "/articles/:id", to: 'posts#show', constraints: {id: /[0-9]+/}
  get "/articles/:article", to: 'posts#get_post_by_slug', as: 'post_slug'

  # for backward supports of old URLs
  #get "/blog", to: 'posts#index'
  get "/blog", to: redirect('/articles')

  # take care of get post by article slug
  get "/blog/:article",  to: redirect('/articles/%{article}')

  # take care of get posts by category
  get "/blog/category/:cat", to: redirect('/category/%{cat}')


  get "/category/:cat", to: 'posts#index'


  get '/dashboard' => 'dashboards#show', as: :user_dashboard
  resources :dashboards do
    patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  end

  # resources :profiles
  resources :profiles, only: [:new, :update, :create, :show, :index] do
    resources :steps, only: [:show, :update], controller: 'profile/steps'
  end

  put '/profiles/:id/apply-partner-code' => 'profiles#apply_partner_code'
  post '/profiles/create-completed-profile' => 'profiles#create_completed_profile', as: 'create_completed_profile'
  
  # Devise routes
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions", passwords: "passwords" }
  devise_scope :user do
    get "/sungevity" => "registrations#new_org_member"
  end

  resources :recommendations, only: [:destroy, :update, :index] do
    post 'complete'
    delete 'undo' => 'recommendations#undo', as: 'undo_complete'
  end

  resources :products do
    post 'toggle_default' => 'products#toggle_default'
  end
  post 'products/update-prices' => 'products#update_all_amazon_prices', as: 'update_product_prices'

  resources :tasks do
    post 'toggle_default' => 'tasks#toggle_default'
  end

  resource :analytics, only: [:show]

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  #post '/posts/:id', to: 'posts#show', as: 'post'
  resources :posts, :path => 'articles'
  #resources :posts
end
