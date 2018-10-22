# frozen_string_literal: true

class MobiusController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_person, except: :check

  def discover
    # Find the user using key_id
    render json: {
      name: @person.name
    }
  end

  def check
    render plain: 'okay', layout: false
  end

  def allowed
    has_blog = params[:project] == "/#{@person.blog.repo_name}"
    render json: {
      status: has_blog,
      message: has_blog ? nil : 'Repository not found',
      repository_path: @person.blog.repo_path
    }
  end

  private

  def find_person
    @person = Person.find_by(id: mobius_params[:key_id])
  end

  def mobius_params
    params.permit(:key_id, :secret_token)
  end
end
