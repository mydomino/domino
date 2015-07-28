Rails.application.routes.draw do
  root 'sessions#index'

  post 'signup' => 'sessions#signup'

  get 'about' => 'sessions#about'
  get 'getstarted' => 'sessions#getstarted'
  get 'terms' => 'sessions#terms'
  get 'privacy' => 'sessions#privacy'

  resources :snippets do
    collection {post :import}
    collection {get :export}
  end

end
