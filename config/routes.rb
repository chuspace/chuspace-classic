# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'


  post '/registerations', to: 'registerations#create'
  get '/auth/:provider/callback', to: 'sessions#github'
  post '/sessions', to: 'sessions#create'
  patch '/logout', to: 'sessions#destroy'

  post '/graphql', to: 'graphql#execute'
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
end
