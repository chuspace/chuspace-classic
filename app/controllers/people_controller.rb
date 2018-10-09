# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :find_person, only: :show

  def show
  end

  def create
    person = Person.new(create_params)

    if person.valid?
      LoginMailer.with(person: person).send_magic_login.deliver_later
      render json: { success: t('.registration.success') }
    else
      render json: { errors: person.api_validation_errors }
    end
  end

  def update
    if Current.person.update(update_params)
      flash[:notice] = 'Profile successfully updated'
    else
      flast[:notice] = 'Something went wrong'
    end

    redirect_to settings_profiles_path
  end

  private

  def create_params
    params.require(:person).permit(:email, :name, :nickname)
  end

  def update_params
    params.require(:person).permit(:email, :name, :bio, :url, :location, :company)
  end

  def find_person
    @person = Person.find_by(nickname: params[:nickname])
  end
end
