# typed: ignore
# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate!

  def index
    authorize! Current.user, to: :edit?

    redirect_to settings_profiles_path
  end
end
