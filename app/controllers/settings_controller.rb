# frozen_string_literal: true

class SettingsController < ApplicationController
  def index
    redirect_to settings_ssh_keys_path
  end
end
