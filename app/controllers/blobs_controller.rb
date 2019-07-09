# typed: ignore
# frozen_string_literal: true

class BlobsController < ApplicationController
  before_action :authenticate!
  before_action :find_blob, only: %i[edit destroy]

  layout 'editor', only: %i[new edit]

  def index
    @blobs = Blob.all.limit(20).order(id: :desc)
  end

  def new
    @blob = Blob.new(author: Current.user, repository: Current.user.repository)
  end

  def edit
    @post = Current.user.posts.build(blob: @blob)
  end

  def create
    Blob.transaction do
      author = Current.user
      repository = author.repository
      next_blob_id = repository.blobs.maximum(:id)&.next || 1
      name = "#{next_blob_id}-blob"
      oid = Rugged::Repository.hash_data(blob_params[:body] || '', :blob)

      blob = repository.blobs.build(
        author: author,
        name: name,
        slug: oid[0..8],
        oid: oid,
        path: "#{name}.md"
      )

      if blob.save
        repository.create_commit(message: params[:commit_message], content: blob_params[:body], path: blob.path)
        redirect_to edit_blob_path(blob)
      else
        render :new
      end
    end
  end

  def destroy
    if @blob.destroy
      @blob.repository.create_commit(committer: Current.user, message: params[:commit_message], action: :remove)
      redirect_to root_path
    else
      redirect_to edit_blob_path(@blob)
    end
  end

  private

  def blob_params
    params.require(:blob).permit(:body)
  end

  def find_blob
    @blob = Current.user.repository.blobs.find_by_slug(params[:slug])
  end
end
