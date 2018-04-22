# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @posts = Post.all.order(id: :desc)
  end
end
