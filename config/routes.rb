# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :login
  patch '/logout', to: 'sessions#destroy', as: :logout

  resources :repos
  resources :check_nicknames, only: :create
  resources :magic_logins, only: :index
  resources :users, except: :show
  resources :posts

  get '/:nickname', to: 'users#show', as: :profile

  namespace 'graphql' do
    post '/', to: 'query#execute'
    if Rails.env.development?
      get '/editor', to: 'editor#index'
      get '/schema', to: 'query#schema'
    end
  end
end
