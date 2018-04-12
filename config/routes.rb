# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  post '/registerations', to: 'registerations#create', as: :registration
  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  get '/magic-login', to: 'sessions#create', as: :magic_login
  post '/sessions', to: 'sessions#create', as: :login
  patch '/logout', to: 'sessions#destroy', as: :logout

  get '/:nickname', to: 'users#show', as: :user

  namespace :graphql do
    post '/', to: 'query#execute', as: :graphql
    get 'editor', to: 'editor#index', as: :graphiql
    get 'schema', to: 'query#schema', as: :schema if Rails.env.development?
  end
end
