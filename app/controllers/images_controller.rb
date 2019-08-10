# typed: ignore
# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: :create
  before_action :find_user_and_repository
  before_action :find_image, only: :show

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob_path = File.join('images', name)
    blob = @repository.create_blob(path: blob_path, content: image_blob.read)

    if blob.persisted?
      render json: { created: true, url: File.join('/', @repository.full_name, blob_path) }
    else
      render json: { message: blob.errors.full_messages.to_sentence, created: false }, status: :unprocessable_entity
    end
  end

  def show
    if @image
      expires_in 1.year, public: true
      send_data @image.content
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def find_user_and_repository
    @user = User.includes(:repository).find_by(nickname: params[:user_nickname])
    @repository = @user.repository
  end

  def find_image
    @image = @repository.blob_at(path: "images/#{params[:path]}.#{params[:format]}")
  end
end
