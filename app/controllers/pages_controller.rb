# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @posts = Post.all.limit(10)
  end
end
