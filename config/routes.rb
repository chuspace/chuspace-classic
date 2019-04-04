# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback', to: 'github#create', as: :omniauth_callback

  resources :sessions, path: 'signin'
  resources :registrations, path: 'signup'
  resources :check_nicknames, only: :create
  resources :magic_logins, only: :index
  resources :people, except: :show
  resources :posts

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
    resources :ssh_keys, path: 'ssh', except: %i[show update]
  end

  get '/:nickname', to: 'people#show', as: :profile
end
