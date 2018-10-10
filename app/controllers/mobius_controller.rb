# frozen_string_literal: true

class MobiusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def discover
    # Find the user using key_id
    person = Person.find_by(id: mobius_params[:key_id])
    render json: {
      name: person.name
    }
  end

  def check
    render plain: 'okay', layout: false
  end

  def allowed
    puts params.inspect
    render json: {
      status: true,
      repository_path: "/Users/admin/chuspace/chuspace/git-storage#{params[:project]}"
    }
  end

  private

  def mobius_params
    params.permit(:key_id, :secret_token)
  end
end
