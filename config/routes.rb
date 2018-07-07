Rails.application.routes.draw do
  resources :weigh_ins

  get 'register', to: 'users#new', as: 'register'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  post 'authenticate' => 'sessions#create'
  get 'account', to: 'users#edit', as: 'account'

  resources :users
  resources :sessions
  resources :password_resets
  resources :groups

  root to: 'users#show'
end
