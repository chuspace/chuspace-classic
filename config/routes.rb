# frozen_string_literal: true

Rails.application.routes.draw do
  get 'invites/create'
  post 'git_shell/access'

  root to: 'pages#index'

  resources :sessions, path: 'signin', only: %i[index create destroy]
  resources :registrations, path: 'signup', only: %i[index create]
  resources :check_nicknames, only: :create

  namespace :check_emails, as: :check do
    post :signup, as: :signup_email
    post :invite, as: :invite_email
  end

  resources :magic_logins, only: :index
  resources :invites, only: :create, param: :code do
    get :approve
  end

  resources :users, except: :show
  resources :posts, except: :show
  resources :post_validations, only: :create

  resources :settings, only: :index

  namespace :settings do
    resources :profiles, path: 'profile', only: %i[index]
    resources :ssh_keys, path: 'ssh', except: %i[show update]
  end

  get '/:nickname', to: 'users#show', as: :profile
  get '/:blog/:slug', to: 'posts#show', as: :blog_post
end
