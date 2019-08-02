# typed: ignore
# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, :find_post_and_edition
  layout 'editor', only: %i[new edit]

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob_path = File.join('images', name)

    blob = if @edition.present?
      @post.repository.create_blob(path: blob_path, content: image_blob.read, branch: @edition.branch_name)
    elsif @post.present?
      @post.repository.create_blob(path: blob_path, content: image_blob.read)
    end

    if blob.persisted?
      render json: { created: true, url: File.join('/', blob_path) }
    else
      render json: { message: blob.errors.full_messages.to_sentence, created: false }, status: :unprocessable_entity
    end
  end

  def show
    image = if @edition.present?
      @edition.repository.blob_at(path: request.path[1..-1], sha: @edition.commit_sha)
    elsif @post.present?
      @post.repository.blob_at(path: request.path[1..-1])
    end

    if image
      expires_in 1.year, public: true
      send_data image.content
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def find_post_and_edition
    post_route = Rails.application.routes.recognize_path(URI(request.referer).path)
    @post = Post.find_by!(slug: post_route[:slug] || post_route[:post_slug])
    @edition = @post.editions.find_by(id: post_route[:id])
  end
end
