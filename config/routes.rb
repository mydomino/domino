Rails.application.routes.draw do

  root 'pages#index'

  post 'signup' => 'pages#signup'
  get 'about' => 'pages#about'
  get 'terms' => 'pages#terms'
  get 'privacy' => 'pages#privacy'

  resources :leads, only: [:create, :new]
  get 'getstarted' => 'leads#new'
  get 'get_started' => 'leads#new'

end
