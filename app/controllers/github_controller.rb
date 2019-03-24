# frozen_string_literal: true


class GithubController < ApplicationController
  before_action :failure, only: :create, if: :malformed_auth?
  skip_before_action :authenticate, only: :create

  def create
    person = Person.from_github(auth_hash)

    if person.save
      login(person)
      redirect_to root_path
    else
      failure
    end
  end

  private

  def failure
    redirect_to root_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def malformed_auth?
    auth_hash.blank? ||
      auth_hash.credentials.blank? ||
      auth_hash.info.name.blank?
  end
end
