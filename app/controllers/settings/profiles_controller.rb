# typed: ignore
# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized

  def index
    @user = Current.user
  end
end
