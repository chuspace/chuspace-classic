# typed: ignore
# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'posts#drafts', constraints: PrivateRootConstraint.new, as: :authenticated_root
  root to: 'pages#index'

  resources :signins, path: 'signin', only: %i[index create destroy]
  resources :signups, path: 'signup', only: %i[index]
  resources :check_nicknames, only: :create
  resources :check_emails, only: :create

  resources :magic_logins, only: :index

  resources :topics

  namespace :autocomplete do
    resources :posts, only: :index
    resources :topics, only: :index
  end

  resources :users, path: 'u', param: :nickname

  resources :posts, path: 'p', param: :slug do
    collection do
      get :drafts
    end
  end

  resources :images, only: %i[create destroy]

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
    resources :ssh_keys, path: 'ssh', except: %i[show update]
  end

  namespace :mobius do
    resources :post_receive, only: :create, constraints: MobiusConstraint.new
  end

  mount Easymon::Engine => '/alive' if Rails.env.production?
end
