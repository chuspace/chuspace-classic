# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :login
  patch '/logout', to: 'sessions#destroy', as: :logout

  resources :repos
  resources :check_nicknames, only: :create
  resources :magic_logins, only: :index
  resources :users
end
