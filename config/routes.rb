# typed: ignore
# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'frontpage#index', constraints: PrivateRootConstraint.new, as: :authenticated_root
  root to: 'pages#index'

  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessible_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get :about, to: 'pages#about', format: :html, as: :about
  get :contact, to: 'pages#contact', format: :html, as: :contact

  resources :signins, path: 'signin', only: %i[index create destroy]
  resources :signups, path: 'signup', only: %i[index create]

  resources :check_nicknames, only: :create
  resources :check_emails, only: :create
  resources :magic_logins, only: :index

  namespace :autocomplete do
    resources :topics, only: :index
  end

  scope :me do
    resources :settings, only: :index
    namespace :settings do
      resources :profiles, path: 'profile', only: %i[index]
    end
  end

  resources :users, path: 'u', param: :nickname, only: %i[show update destroy] do
    resources :drafts, only: :index, module: 'users'
  end

  resources :publications, only: %i[new create index edit], param: :slug

  mount Easymon::Engine => '/alive' if Rails.env.production?
  mount AvatarUploader.derivation_endpoint => 'avatar/variants'
  mount PreviewImageUploader.derivation_endpoint => 'images/variants'

  resources :publications, path: '', param: :slug, only: %i[show update destroy] do
    resources :images, only: %i[create show destroy], module: 'publications'
    resources :drafts, only: :index, module: 'publications'

    resources :people, path: 'people', only: %i[index update destroy], module: 'publications' do
      collection { get :autocomplete }
    end

    resources :invitations, only: :create, module: 'publications' do
      collection { get :accept }
    end

    resources :posts, path: '', param: :slug, only: %i[show destroy]
    resources :posts, path: 'p', param: :slug, except: :show do
      resources :publish, only: %i[index create], module: 'posts'
      resources :shares, only: :show, module: 'posts'
      resources :likes, path: 'like', only: :create, module: 'posts'
      resources :autocomplete, only: :index, module: 'posts'
    end
  end
end
