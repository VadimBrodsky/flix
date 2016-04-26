Rails.application.routes.draw do
  resources :genres
  root 'movies#index'

  get 'movies/filter/flops' => 'movies#index', scope: :flops

  resources :movies do
    resources :reviews
    resources :favorites
  end

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resources :users
  resource :session
end
