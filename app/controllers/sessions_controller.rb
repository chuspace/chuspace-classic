# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :failure, only: :github, if: :malformed_auth?
  skip_before_action :authenticate, on: :github

  def github
    user = User.from_github(auth_hash)
    if user
      Git::CreateAndStoreRepo.call(user: user)
      login(user) if user
      redirect_to root_path
    else
      failure
    end
  end

  def failure
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_path
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end

    def malformed_auth?
      auth_hash.blank? ||
        auth_hash.credentials.blank? ||
        auth_hash.info.name.blank?
    end
end
