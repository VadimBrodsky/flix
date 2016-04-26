Rails.application.routes.draw do
  resources :genres
  root 'movies#index'

  # use regex to constrain the scope names
  # get 'movies/:scope' => 'movies#index', constraints: { scope: /hits|flops|upcoming|recent/ }, as: :filtered_movies

  # use loop to dynamically create list of routes
  # redirect to filter namespace
  %w(hits flops upcoming recent).each do |scope|
    get "movies/#{scope}" => redirect("movies/filter/#{scope}")
  end

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
