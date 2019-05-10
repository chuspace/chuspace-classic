# frozen_string_literal: true

class PostValidationsController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds

  def create
    ssh_key = SshKey.find_by(id: params[:key_id].split('-').last)
    user = ssh_key&.user
    blog = user.blogs.find_by(repo_name: params[:repo_name])

    posts = params[:blobs].map { |blob| Post.find_or_initialize_from_blob(author: user, blob: blob) }

    posts.map(&:valid?)

    errors = posts.flat_map { |post| "#{post.blob_name}:\n #{post.api_validation_errors_sentence}" }.join("\n")

    render json: { valid: posts.all?(&:valid?), errors: errors }
  end
end
