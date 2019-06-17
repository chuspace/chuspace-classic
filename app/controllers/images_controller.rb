# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]

  layout 'editor', only: %i[new edit]

  def create
    repository = Current.user.repository
    uploaded_io = params[:image]
    blob_name = uploaded_io.original_filename
    blob_path = File.join(Current.user.nickname, 'images', blob_name)
    image = repository.images.find_by(blob_path: blob_path)

    unless image
      image = repository.images.create(image: uploaded_io, blob_path: blob_path)
      repository.commit(content: image.image.read, message: "Added #{blob_path}", path: blob_path)
    end

    render json: { url: image.image.imgproxy_url(width: 700, height: 350, resizing_type: :fill, sharpen: 1) }
  end
end
