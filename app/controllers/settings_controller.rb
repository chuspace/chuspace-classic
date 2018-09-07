# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    redirect_to settings_profiles_path
  end
end
