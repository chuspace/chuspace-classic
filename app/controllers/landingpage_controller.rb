# typed: ignore
# frozen_string_literal: true

class LandingpageController < ApplicationController
  def index
    @user = User.new
  end
end
