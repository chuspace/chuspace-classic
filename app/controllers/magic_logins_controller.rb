# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    person = Person.find_by(auth_token: inputs[:auth_token])

    if person
      login
      person.regenerate_auth_token
    end

    redirect_to root_path
  end
end
