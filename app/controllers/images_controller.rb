# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    image = Current.user.images.find_or_initialize_by(image_blob: params[:image], repository: Current.user.repository)


    if image.valid?
      commit_message = image.new_record? ? "Added #{blob_path}" : "Updated #{blob_path}"
      user.repository.create_commit(content: io.read, message: commit_message, path: blob_path)
      image.save

      render json: { url: image.blob_url }
    else
      puts image.errors.inspect

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
