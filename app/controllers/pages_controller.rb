# typed: ignore
# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @user = User.new
  end
end
