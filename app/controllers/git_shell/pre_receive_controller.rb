# frozen_string_literal: true

module GitShell
  class PreReceiveController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::Renderers::All
    include ActionController::MimeResponds
    include EncodingHelper

    def create
      ssh_key = SshKey.find_by(id: params[:key_id].split('-').last)
      user = ssh_key&.user
      blog = user.blogs.find_by(repo_name: params[:repo_name])

      puts params[:blobs].inspect
      blob_errors = params[:blobs].map do |(blob, filename)|
        post = Post.find_or_initialize_from_blob(author: user, blob: encode!(blob))
        next if post && post.valid?

        { blob: post ? post.api_validation_errors_sentence : 'Invalid frontmatter' }
      end.compact

      render json: { blob_errors: blob_errors.to_json }
    end
  end
end
