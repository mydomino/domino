Rails.application.routes.draw do

  root 'pages#index'

  get 'team' => 'pages#team'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'faq' => 'pages#faq'
  get 'example' => 'pages#example'
  get '/welcome-email/:profile_id' => 'profiles#welcome_email'
  get '/legacy-user-registration-email/:lu_id' => 'profiles#lu_registration_email'
  get "/dashboard/:slug" => redirect{ |params, req| "users/sign_up?#{req.params.to_query}" }
  # get "/dashboard/:slug" => redirect{ |params, req| "/?#{req.params.to_query}" }



  get '/dashboard' => 'dashboards#show', as: :user_dashboard
  resources :dashboards do
    patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  end

  resources :profiles
  put '/profiles/:id/apply-partner-code' => 'profiles#apply_partner_code'

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

  get '/blog' => redirect("/blog/")

end
