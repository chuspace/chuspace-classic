# typed: ignore
# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: :create
  before_action :find_image, only: :show

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob = Current.user.repository.create_blob(path: name, content: image_blob.read)
    image = Current.user.repository.images.find_or_initialize_by(name: name)
    image.assign_attributes(image: image_blob, blob_path: blob.path)

    if blob.persisted? && image.save
      render json: { created: true, url: blob.absolute_path }
    else
      render json: { message: image.errors.full_messages.to_sentence, created: false }, status: :unprocessable_entity
    end
  end

  def show
    if @image
      expires_in 1.year, public: true
      send_data @image.blob.io.read
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def find_image
    @image = Image.find_by(name: params[:id])
  end
end
