# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :sessions
  patch '/logout', to: 'sessions#destroy', as: :logout

  get '/register', to: 'registrations#new', as: :new_registeration
  get '/login', to: 'sessions#new', as: :new_session

  resources :repos
  resources :check_nicknames, only: :create
  resources :magic_logins, only: :index
  resources :users, except: :show
  resources :posts

  get '/:nickname', to: 'users#show', as: :profile
end
