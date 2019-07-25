# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    uploaded_file = params[:image]
    dirname = File.dirname(Image::ROOT_PATH)
    name = uploaded_file.original_filename
    blob_path = File.join(dirname, name)

    image = Current.user.images.find_or_initialize_by(name: name, blob_path: blob_path, repository: Current.user.repository)
    S3Service.upload_image(io: uploaded_file, filename: blob_path, bucket: Current.user.nickname)
    commit_message = image.new_record? ? "Added #{blob_path}" : "Updated #{blob_path}"

    if image.save
      Current.user.repository.create_commit(content: uploaded_file.read, message: commit_message, path: blob_path)
      render json: { url: File.join('/', blob_path) }
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
