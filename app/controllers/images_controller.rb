# typed: false
# frozen_string_literal: true

require 'mimemagic'

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    repository = Current.user.repository
    uploaded_io = params[:image]
    blob_name = uploaded_io.original_filename
    blob_path = File.join('/', repository.name, blob_name)
    io = uploaded_io.read
    content_type = MimeMagic.by_path(blob_name).type

    repository.commit(content: io, message: "Added #{blob_name}", path: blob_name)
    Current.user.minio_client.put_object(
      key: repository.name, body: io, bucket: Current.user.nickname, content_type: content_type
    )

    render json: { url: blob_path }
  end
end
