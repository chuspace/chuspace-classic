# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    uploaded_file = params[:image]
    dirname = FasterPath.dirname(Image::ROOT_PATH)
    io = uploaded_file.read
    name = uploaded_file.original_filename
    blob_path = FasterPath.plus(dirname, name)
    image = Current.user.images.build(user: Current.user, name: name, blob_path: blob_path, repository: Current.user.repository, image: params[:image])

    if image.save
      Current.user.repository.create_commit(content: io, message: "Added #{blob_path}", path: blob_path)
      render json: { url: FasterPath.plus('/', blob_path) }
    else
      render json: { created: false }, status: :unprocessable_entity
    end
  end

  def show
    image = Image.find_by(blob_path: request.path[1..-1])

    if image
      redirect_to image.image.imgproxy_url(**builder_options)
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

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
