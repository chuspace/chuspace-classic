class DraftsController < ApplicationController
  before_action :authenticate!

  def index
    @drafts = Post.draft.limit(20).order(id: :desc)
  end
end
