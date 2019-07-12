# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    repository = Current.user.repository
    uploaded_io = params[:image]
    blob_path = File.join('images', uploaded_io.original_filename)
    absolute_blob_path = File.join('', blob_path)
    io = uploaded_io.read
    content_type = MimeMagic.by_path(blob_path).type

    repository.create_commit(content: io, message: "Added #{blob_path}", path: blob_path)
    Current.user.minio_client.put_object(key: blob_path, content_type: content_type, bucket: Current.user.nickname, body: io)

    render json: { url: absolute_blob_path }
  end

  def show
    filename = request.path.chomp('/')
    response = Current.user.minio_client.get_object(key: filename, bucket: Current.user.nickname)
    send_data response.body.read, type: response.content_type, disposition: :inline
  end
end
