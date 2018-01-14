# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#index'

  scope 'graphql' do
    post '/', to: 'graphql#execute'
  end
end
