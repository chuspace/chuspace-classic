# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @posts = Post.all.includes(:blog, :author).limit(20)
  end
end
