Rails.application.routes.draw do
  resources :genres
  root 'movies#index'

  get 'movies/filter/:scope' => 'movies#index', as: :filtered_movies

  resources :movies do
    resources :reviews
    resources :favorites
  end

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resources :users
  resource :session
end
