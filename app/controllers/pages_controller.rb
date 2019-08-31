# typed: ignore
# frozen_string_literal: true

class PagesController < ApplicationController
  skip_verify_authorized

  def index
    @user = User.new
  end
end
