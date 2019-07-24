# typed: ignore
# frozen_string_literal: true

class Settings::RepositoriesController < ApplicationController
  before_action :authenticate!

  def index
    @user = Current.user
  end
end
