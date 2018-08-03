# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, except: %i[index]

  def show
  end

  private
    def find_user
      @user = User.find_by(nickname: params[:nickname])
    end
end
