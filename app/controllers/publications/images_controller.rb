# typed: ignore
# frozen_string_literal: true

class Publications::ImagesController < ApplicationController
  before_action :authenticate!, only: :create
  before_action :find_publication
  skip_verify_authorized only: :show

  def create
    image_blob = params[:image]
    name = image_blob.original_filename.to_slug&.to_ascii&.to_s
    blob_path = Pathname.new(Repository::IMAGES_ROOT_PATH).join(name).to_path
    blob = @publication.repository.create_blob(path: blob_path, content: image_blob.read)

    authorize! @publication, to: :publish?

    if blob.persisted?
      render json: { created: true, url: publication_image_path(@publication, name) }
    else
      render json: { created: false, message: blob.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def show
    @image = @publication.repository.blobs.find { |blob| blob.name == params[:id] }

    if @image
      expires_in 1.year, public: true
      send_data @image.content, filename: @image.name, disposition: :inline, type: @image.mime.content_type
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def destroy
    @image = @publication.repository.blobs.find { |blob| blob.name == params[:id] }

    authorize! @publication, to: :publish?

    if @image.destroy(committer: Current.user)
      render json: { destroyed: true, url: nil }
    else
      render json: { message: @image.errors.full_messages.to_sentence, destroyed: false }, status: :unprocessable_entity
    end
  end

  private

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end
end
