# typed: ignore
# frozen_string_literal: true

class FrontpageController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized

  def index
    @posts = Post.featured.includes(:author, publication: :owner).limit(20).order(id: :desc)
  end
end
