# typed: false
# frozen_string_literal: true

class Posts::EditionsController < ApplicationController
  before_action :authenticate!, :find_post
  before_action :find_edition_and_authorize, except: %i[index create]
  after_action :verify_authorized, only: %[show edit create]

  layout 'editor', only: :edit

  def index
    redirect_to post_edition_path(@post, @post.editions.first)
  end

  def show
    authorize @edition
  end

  def edit
    authorize @edition
  end

  def merge
    authorize @edition
    commit, error = @edition.repository.merge_commit(@edition.commit_sha, @edition.editor, @post.author, "#{@edition.editor.name} contributed some changes")
    @edition.merge
    @edition.assign_attributes(commit_sha: commit)

    if commit && @edition.save
      redirect_to post_path(@post)
    else
      redirect_to post_edition_path(@post, @edition)
    end
  end

  def create
    branch_name = "edition_#{Current.user.nickname}_#{@post.id}"
    commit_sha = @post.repository.commit_sha
    @edition = Current.user.contributions.find_or_initialize_by(post: @post, branch_name: branch_name, commit_sha: commit_sha)
    @post.repository.branches.create(branch_name, commit_sha) unless @edition.persisted?

    if @edition.save!
      redirect_to edit_post_edition_path(@post, @edition)
    else
      redirect_to post_path(@post)
    end
  end

  def update
    if @edition.update(update_params)
      redirect_to post_edition_path(@post, @edition)
    else
      redirect_to edit_post_edition_path(@post, @edition)
    end
  end

  def destroy
    authorize @edition

    if @edition.destroy
      redirect_to post_path(@post)
    else
      redirect_to edit_post_edition_path(@post, @edition)
    end
  end

  private

  def find_post
    @post = Post.find_by(slug: params[:post_slug])
  end

  def find_edition_and_authorize
    @edition = @post.editions.find(params[:id])
  end

  def update_params
    params.require(:edition).permit(:status)
  end
end
