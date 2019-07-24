# typed: ignore
# frozen_string_literal: true

class SignupsController < ApplicationController
  before_action :redirect_if_registered

  def index
    @user = User.new
  end

  private

  def redirect_if_registered
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end
