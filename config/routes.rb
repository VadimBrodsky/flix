Rails.application.routes.draw do
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  get 'signup' => 'users#new'
  resources :users
end
