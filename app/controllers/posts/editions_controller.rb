# typed: false
# frozen_string_literal: true

class Posts::EditionsController < ApplicationController
  before_action :authenticate!, :find_post
  layout 'editor', only: %i[edit show]

  def show
    @edition = @post.editions.find(params[:id])
  end

  def edit
    @edition = @post.editions.find(params[:id])
  end

  def create
    @edition = Current.user.contributions.build(post: @post)
    branch_name = "edition_#{Current.user.nickname}_#{@post.id}"
    branch = @post.repository.branches.create(branch_name, @post.repository.commit_sha)

    @edition.assign_attributes(
      branch_name: branch.name,
      commit_sha: @post.repository.commit_sha
    )

    if @edition.save!
      redirect_to edit_post_edition_path(@post, @edition)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end
end
