Rails.application.routes.draw do

  root 'pages#index'

  get 'team' => 'pages#team'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'faq' => 'pages#faq'
  get 'example' => 'pages#example'
  get '/resend-welcome-email/:id' => 'profiles#resend_welcome_email'
  get '/legacy-user-registration-email/:lu_id' => 'profiles#lu_registration_email'
  get "/dashboard/:slug" => redirect{ |params, req| "users/sign_up?#{req.params.to_query}" }

  get "/continue/:profile_id" => 'pages#index'

  get "/newsletter-subscribe" => 'pages#newsletter_subscribe'
  get "/blog" => redirect("http://blog.mydomino.com/")
  get "/blog/:article" => redirect{ |params, req| "http://blog.mydomino.com/#{params[:article]}"}
  get "/blog/category/:category" => redirect{ |params, req| "http://blog.mydomino.com/category/#{params[:category]}"}
  
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
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions", passwords: "passwords" }

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

end
