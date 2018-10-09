# frozen_string_literal: true

class MobiusController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check
    render plain: 'okay', layout: false
  end

  def allowed
    puts params.inspect
    render json: {
      status: true,
      repository_path: '/Users/admin/chuspace/chuspace/git/repositories/gauravtiwari/blog'
    }
  end
end
