# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  post '/registerations', to: 'registerations#create', as: :registration
  get '/auth/:provider/callback', to: 'sessions#github', as: :omniauth_callback
  post '/sessions', to: 'sessions#create', as: :login
  patch '/logout', to: 'sessions#destroy', as: :logout

  post '/graphql', to: 'graphql#execute', as: :graphql
end
