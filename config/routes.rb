Rails.application.routes.draw do

  devise_for :concierges
  get 'concierges/my-profile' => 'concierges#edit', as: 'edit_concierge'
  resources :concierges, only: [:update]

  root 'pages#index'

  post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'solar' => 'pages#solar'

  resources :leads, only: [:create, :new, :index]
  resources :amazon_storefronts, path: '/storefronts/', only: [:new, :create, :show, :index] do
    resources :recommendations, only: [:new, :create]
  end
  resources :recommendations, only: [] do
    post 'complete'
  end

  resources :amazon_products, path: '/products/', only: [:new, :create, :edit, :update, :index]
  resources :tasks, only: [:new, :create]

  get 'getstarted' => 'leads#new'
  get 'get_started' => 'leads#new'

  get '/blog' => redirect("/blog/")

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
