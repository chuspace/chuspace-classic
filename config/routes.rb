# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :sessions
  patch '/logout', to: 'sessions#destroy', as: :logout

  get '/register', to: 'registrations#new', as: :new_registration
  get '/login', to: 'sessions#new', as: :new_session

  resources :check_nicknames, only: :create
  resources :magic_logins, only: :index
  resources :people, except: :show
  resources :posts

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
  end

  get '/:nickname', to: 'people#show', as: :profile
end
