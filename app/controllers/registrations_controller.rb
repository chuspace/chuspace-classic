# frozen_string_literal: true

class RegistrationsController < ApplicationController
  skip_before_action :authenticate, on: :create

  def create
    user = User.from_email(email)
    login(user) if user
    redirect_to '/'
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      logout
      redirect_to '/'
    end
  end

  private
    def registeration_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
