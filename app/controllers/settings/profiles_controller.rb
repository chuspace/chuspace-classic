# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :authenticate!

  def index
    @user = Current.user
  end
end
