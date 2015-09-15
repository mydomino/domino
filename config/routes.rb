Rails.application.routes.draw do

  devise_for :concierges, skip: [:registrations]                                   
  as :concierge do
    get 'concierges/edit' => 'devise/registrations#edit', :as => 'edit_concierge_registration'    
    put 'concierges' => 'devise/registrations#update', :as => 'concierge_registration'
    get 'concierges/my-profile' => 'concierges#edit', as: 'edit_concierge'  
  end
  resources :concierges, only: [:update]

  root 'pages#index'
  post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'solar' => 'pages#solar'

  resources :leads, only: [:create, :new, :index]
  resources :dashboards, path: '/dashboard/', only: [:new, :create, :show, :index] do
    resources :recommendations, only: [:new, :create]
    patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  end
  resources :recommendations, only: [:destroy, :update] do
    post 'complete'
    delete 'undo' => 'recommendations#undo', as: 'undo_complete'
  end

  resource :analytics, only: [:show]

  resources :amazon_products, path: '/products/', only: [:new, :create, :edit, :update, :index]
  resources :tasks

  get 'getstarted' => 'leads#new'
  get 'get_started' => 'leads#new'

  get '/blog' => redirect("/blog/")

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
