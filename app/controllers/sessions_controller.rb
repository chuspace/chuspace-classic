# typed: ignore
# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    puts auth_hash.inspect

    @user =
      User.find_or_create_by(provider_name: auth_hash['provider'], provider_uid: auth_hash['uid']).tap do |user|
        user.provider_token = auth_hash['credentials']['token']
        user.provider_secret = auth_hash['credentials']['secret']
        user.name = auth_hash['info']['name']
        user.email = auth_hash['info']['email']
        user.email = auth_hash['info']['nickname']
        user.avatar_remote_url = auth_hash['raw_info']['avatar_url']
      end

    login(@user)

    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
