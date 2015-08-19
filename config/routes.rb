Rails.application.routes.draw do

  root 'pages#index'

  post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'

  resources :leads, only: [:create, :new, :index]
  get 'getstarted' => 'leads#new'
  get 'get_started' => 'leads#new'

  get '/blog' => redirect("/blog/")

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

end
