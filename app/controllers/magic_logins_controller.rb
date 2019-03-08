# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    person = Person.find_by(auth_token: params[:token])

    if person
      login(person)
      person.regenerate_auth_token
    end

    redirect_to root_path
  end
end
