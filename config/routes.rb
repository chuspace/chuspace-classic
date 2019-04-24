# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  resources :sessions, path: 'signin', only: %i[index create destroy]
  resources :registrations, path: 'signup', only: %i[index create]
  resources :check_nicknames, only: :create
  resources :check_emails, only: :create
  resources :magic_logins, only: :index
  resources :users, except: :show
  resources :posts

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
    resources :ssh_keys, path: 'ssh', except: %i[show update]
  end

  get '/:nickname', to: 'users#show', as: :profile
end
