class FrontpageController < ApplicationController
  before_action :authenticate!

  def index
    @posts = Post.published.limit(20).order(id: :desc)
  end
end
