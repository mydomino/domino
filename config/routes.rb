Rails.application.routes.draw do

  root 'pages#index'

  post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'
  get 'solar' => 'pages#solar'

  resources :leads, only: [:create, :new, :index]
  resources :amazon_storefronts, only: [:new]
  resources :amazon_products, only: [:new, :create, :index]

  get 'getstarted' => 'leads#new'
  get 'get_started' => 'leads#new'

  get '/blog' => redirect("/blog/")

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
