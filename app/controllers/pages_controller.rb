# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    posts = Post.all.order(id: :desc)
    render component: 'posts/index', props: { posts: @posts }
  end
end
