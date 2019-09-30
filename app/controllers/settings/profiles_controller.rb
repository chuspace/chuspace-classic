# typed: ignore
# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :authenticate!

  def index
    authorize! Current.user, to: :edit?
    @user = Current.user
  end
end
