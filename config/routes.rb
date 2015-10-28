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
  resources :dashboards, path: '/dashboard/', only: [:new, :create, :show, :index, :destroy] do
    resources :recommendations, only: [:new, :create]
    patch 'bulk_update' => 'recommendations#bulk_update', as: 'bulk_update'
  end
  resources :recommendations, only: [:destroy, :update] do
    post 'complete'
    delete 'undo' => 'recommendations#undo', as: 'undo_complete'
  end

  resource :analytics, only: [:show]

  resources :products, path: '/products/', only: [:new, :create, :edit, :update, :index]
  resources :tasks

  get 'getstarted' => 'leads#new'
  resource :get_started, only: [:show, :create] do
    get '1' => 'get_starteds#step_1', as: 'step_1'
    get '2' => 'get_starteds#step_2', as: 'step_2'
    get '3' => 'get_starteds#step_3', as: 'step_3'
    post 'finish' => 'get_starteds#finish', as: 'finish'
  end

  get 'EnergyAwareness' => 'leads#energy_awareness'
  get 'energy-awareness' => 'leads#energy_awareness'

  get 'EnergyAwareness' => 'leads#energy_awareness'


  get '/blog' => redirect("/blog/")

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
