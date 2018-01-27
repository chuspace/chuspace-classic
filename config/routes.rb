# frozen_string_literal: true

Rails.application.routes.draw do
  get 'logins/create'
  get 'logins/new'
  get 'signups/create'
  get 'signups/new'
  root to: 'pages#index'
end
