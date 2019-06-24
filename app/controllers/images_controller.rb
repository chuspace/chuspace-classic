# typed: false
# frozen_string_literal: true

class ImagesController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  layout 'editor', only: %i[new edit]

  def create
    repository = Current.user.repository
    uploaded_io = params[:image]
    blob_name = uploaded_io.original_filename
    blob_path = File.join('/', repository.name, blob_name)

    repository.commit(content: image.image.read, message: "Added #{blob_name}", path: blob_name)

    render json: { url: blob_path }
  end
end
