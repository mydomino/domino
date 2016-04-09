Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :profiles
  put '/profiles/:id/apply-partner-code' => 'profiles#apply_partner_code'

  devise_for :users, controllers: { registrations: "registrations" }
  
  root 'pages#index'
  # post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  #get 'solar' => 'pages#solar'

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
  get '/dashboard' => 'dashboards#show', as: :user_dashboard
  resources :dashboards
  # get '/dashboard/:id' => 'dashboards#show'
  # get '/dashboard' => 'dashboards#show'
  # get '/dashboards' => 'dashboards#index'
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

  # get 'getstarted' => 'leads#new'
  # resource :get_started, only: [:show, :create] do
  #   get '1' => 'get_starteds#step_1', as: 'step_1'
  #   get '2' => 'get_starteds#step_2', as: 'step_2'
  #   get '3' => 'get_starteds#step_3', as: 'step_3'
  #   post 'finish' => 'get_starteds#finish', as: 'finish'
  # end

  resources :contests
  #get '/smart-home' => 'leads#energy_awareness'
  #redirecting the contest page to the root path for now
  get '/smart-home' => 'pages#index'

  resource :analytics, only: [:show]

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get '/blog' => redirect("/blog/")

end
