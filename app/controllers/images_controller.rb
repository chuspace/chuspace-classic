# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob_path = File.join('images', name)
    blob = Current.user.repository.create_blob(path: blob_path, content: image_blob.read)
    puts blob.object.inspect

    if blob.persisted?
      render json: { created: true, url: File.join('/', blob_path) }
    else
      render json: { message: blob.errors.full_messages.to_sentence, created: false }, status: :unprocessable_entity
    end
  end

  def show
    image = Current.user.repository.blob_at(path: request.path[1..-1])

    if image
      expires_in 1.year, public: true
      send_data image.content
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
