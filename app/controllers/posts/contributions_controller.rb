# typed: strong
# frozen_string_literal: true

class Posts::ContributionsController < ApplicationController
  before_action :authenticate!, :find_post
  layout 'editor', only: %i[edit show]

  def show
    @contribution = @post.contributions.find(params[:id])
  end

  def edit
    @contribution = @post.contributions.find(params[:id])
  end

  def create
    @contribution = Current.user.contributions.build(post: @post)
    branch_name = "contribution_#{Current.user.nickname}_#{@post.id}"
    branch = @post.repository.branches.create(branch_name, @post.repository.commit_sha)

    @contribution.assign_attributes(
      branch_name: branch.name,
      commit_sha: branch.target
    )

    if @contribution.save!
      redirect_to edit_post_contribution_path(@post, @contribution)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end
end
