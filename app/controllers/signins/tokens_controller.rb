# typed: ignore
# frozen_string_literal: true

class Signins::TokensController < ApplicationController
  before_action :redirect_if_signedin, except: :destroy
  skip_verify_authorized

  def index
    @user = User.new
  end

  def create
    user = User.find_by(auth_token: signin_params[:auth_token])

    if user
      login(user)
      redirect_to root_url
    else
      redirect_to signin_token_index_url, notice: t('.signins.tokens.create.invalid')
    end
  end

  private

  def signin_params
    params.require(:signin).permit(:auth_token)
  end

  def redirect_if_signedin
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end
