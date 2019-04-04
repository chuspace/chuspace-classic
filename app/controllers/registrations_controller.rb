# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :redirect_if_registered

  def index
  end

  def new
  end

  def create
    person = Person.from_email(create_params)

    if person.save
      LoginMailer.with(person: person).send_magic_login.deliver_later
      render json: { success: t('.registration.success') }
    else
      render json: { errors: person.api_validation_errors }
    end
  end

  private

  def redirect_if_registered
    redirect_back(fallback_location: root_path) if Current.person.present?
  end

  def create_params
    params.require(:person).permit(:email, :name, :nickname)
  end
end
