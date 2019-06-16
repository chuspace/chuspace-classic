# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]

  layout 'editor', only: %i[new edit]

  def create
    repository = Current.user.repository
    uploaded_io = params[:image]
    blob_name = uploaded_io.original_filename
    blob_path = File.join(Current.user.nickname, 'images', blob_name)

    image = repository.images.find_or_initialize_by(blob_path: blob_path)
    image.image = uploaded_io

    if image.save
      repository.commit(content: image.image.read, message: "Added #{blob_path}", path: blob_path)
      render json: { url: image.image.imgproxy_url(width: 700, height: 350, resizing_type: :fill,
      sharpen: 1) }
    else
      render json: { error: image.api_validation_errors }
    end
  end
end
