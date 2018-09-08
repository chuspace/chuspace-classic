# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :failure, only: :github, if: :malformed_auth?
  skip_before_action :authenticate, on: %i[create github]

  def new
  end

  def create
    person = Person.find_by(email: params[:email])

    if person
      PersonMailer.with(person: person).send_magic_login.deliver_later
      render json: { success: t('.login.success') }
    else
      render json: { errors: errors_for(:email, t('.login.email_not_found')) }
    end
  end

  def github
    person = Person.from_github(auth_hash)
    if person
      login(person) if person
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
