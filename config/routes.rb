Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  
  ActiveAdmin.routes(self)

  resources :profiles
  put '/profiles/:id/apply-partner-code' => 'profiles#apply_partner_code'

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  
  root 'pages#index'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'

  #concierge routes
  # devise_for :concierges, skip: [:registrations]                                   
  # as :concierge do
  #   get 'concierges/edit' => 'registrations#edit', :as => 'edit_concierge_registration'    
  #   put 'concierges' => 'devise/registrations#update', :as => 'concierge_registration'
  #   get 'concierges/my-profile' => 'concierges#edit', as: 'edit_concierge'  
  # end
  # resources :concierges, only: [:update]

  #lead routes
  # resources :leads, only: [:create, :new, :index]
  get '/dashboard/:slug' => 'pages#mydomino_updated'
  get '/dashboard' => 'dashboards#show', as: :user_dashboard
  resources :dashboards do
    patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  end
  # resources :dashboards, path: '/dashboard/', only: [:new, :create, :show, :index, :destroy] do
  #   # resources :recommendations, only: [:new, :create]
  #   # patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  # end

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

  resources :contests
  #redirecting the contest page to the root path for now
  get '/smart-home' => 'pages#index'

  resource :analytics, only: [:show]

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get '/blog' => redirect("/blog/")

end
