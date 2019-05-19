# frozen_string_literal: true

Rails.application.routes.draw do
  get 'invites/create'
  post 'git_shell/access'

  root to: 'users#show', constraints: PrivateRootConstraint.new, as: :authenticated_root
  root to: 'pages#index'

  resources :signins, path: 'signin', only: %i[index create destroy]
  resources :signups, path: 'signup', only: %i[index]
  resources :check_nicknames, only: :create

  namespace :check_emails, as: :check do
    post :signup, as: :signup_email
    post :invite, as: :invite_email
  end

  resources :magic_logins, only: :index
  resources :invites, only: :create

  resources :users, path: 'u', param: :nickname
  resources :posts, path: 'p', param: :slug
  resources :post_validations, only: :create

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
    resources :ssh_keys, path: 'ssh', except: %i[show update]
  end

  mount Easymon::Engine => '/alive' if Rails.env.production?
end
