# typed: ignore
# frozen_string_literal: true

class FrontpageController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized

  def index
    @posts = Post.listed.includes(:author, :publication).limit(20).order(id: :desc)
  end
end
