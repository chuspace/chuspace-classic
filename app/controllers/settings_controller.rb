# typed: ignore
# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized

  def index
    redirect_to settings_profiles_path
  end
end
