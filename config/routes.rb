# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  namespace :mobius do
    get :check
    get :discover
    post :allowed
  end

  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :sessions
  patch '/logout', to: 'sessions#destroy', as: :logout

  scope :register do
    get '/', to: 'registrations#new', as: :new_registration
    get '/email', to: 'registrations#email', as: :email_registration
  end

  scope :login do
    get '/', to: 'sessions#new', as: :new_session
    get '/email', to: 'sessions#email', as: :email_session
  end

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
