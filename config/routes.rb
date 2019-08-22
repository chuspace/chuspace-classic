# typed: ignore
# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'frontpage#index', constraints: PrivateRootConstraint.new, as: :authenticated_root
  root to: 'landingpage#index'

  get :sw, to: 'service_worker#file', format: :js
  get :manifest, to: 'service_worker#manifest', format: :json

  resources :signins, path: 'signin', only: %i[index create destroy] do
    collection do
      resources :tokens, only: %i[index create], as: :signin_token, module: :signins, path: :token
    end
  end

  resources :signups, path: 'signup', only: %i[index create]

  resources :check_nicknames, only: :create
  resources :check_emails, only: :create
  resources :magic_logins, only: :index
  resources :topics, only: %i[index show]

  namespace :autocomplete do
    resources :topics, only: :index
  end

  scope :me do
    resources :settings, only: :index
    namespace :settings do
      resources :profiles, path: 'profile', only: %i[index]
      resources :ssh_keys, path: 'ssh', except: %i[show update]
      resources :repositories, path: 'repository', only: :index
    end
  end

  resources :images, only: %i[create destroy]

  resources :posts, path: 'p', param: :slug, except: :show do
    resources :publish, only: %i[index create], module: 'posts'
  end

  namespace :mobius do
    resources :post_receive, only: :create, constraints: MobiusConstraint.new
  end

  mount Easymon::Engine => '/alive' if Rails.env.production?

  resources :users, path: '', param: :nickname, only: %i[show update destroy] do
    resources :images, only: %i[show destroy]
    resources :drafts, only: :index, controller: :user_drafts
    resources :posts, path: '', param: :slug, only: %i[show destroy]
    resources :repositories, path: '', param: :slug, only: :show, format: :git
  end
end
