# typed: ignore
# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: :create

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob_path = Pathname.new(Repository::IMAGES_ROOT_PATH).join(name).to_path
    blob = Current.user.repository.create_blob(path: blob_path, content: image_blob.read)

    if blob.persisted?
      render json: { created: true, url: user_image_path(Current.user, blob.name) }
    else
      render json: { message: blob.errors.full_messages.to_sentence, created: false }, status: :unprocessable_entity
    end
  end

  def show
    @user = User.includes(:repository).find_by(nickname: params[:user_nickname])
    @image = @user.repository.blobs.find { |blob| blob.name == params[:id] }

    if @image
      expires_in 1.year, public: true
      send_data @image.content, filename: @image.name, disposition: :inline, type: @image.mime.content_type
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def destroy
    @user = User.includes(:repository).find_by(nickname: params[:user_nickname])
    @image = @user.repository.blobs.find { |blob| blob.oid == params[:id] }

    if @image.destroy(committer: Current.user)
      render json: { destroyed: true, url: nil }
    else
      render json: { message: @image.errors.full_messages.to_sentence, destroyed: false }, status: :unprocessable_entity
    end
  end
end
