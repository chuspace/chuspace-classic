# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    image_blob = params[:image]
    name = image_blob.original_filename
    blob_path = File.join(Image::ROOT_DIRNAME, name)

    image = Current.user.images.find_or_initialize_by(blob_path: blob_path, repository: Current.user.repository)
    image.image_blob = image_blob
    image.name = name

    if image.valid?
      image.create_commit
      image.save

      render json: { url: image.blob_url }
    else
      render json: { created: false }, status: :unprocessable_entity
    end
  end

  def show
    image = Image.find_by(blob_path: request.path[1..-1])

    if image
      redirect_to image.image_url(builder_options)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def blob_params
    params.permit(:path, :width, :quality)
  end

  def builder_options
    options = {}

    if blob_params[:width]
      options[:width] = blob_params[:width]
      options[:resizing_type] = :fill
    end

    options[:quality] = blob_params[:quality] + '%' if blob_params[:quality]

    options
  end
end
