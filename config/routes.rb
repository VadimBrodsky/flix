Rails.application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :reviews
    resources :favorites
  end

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resources :users
  resource :session
end
