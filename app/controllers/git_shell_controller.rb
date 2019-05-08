# frozen_string_literal: true

class GitShellController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds
  include Rails.application.routes.url_helpers

  def access
    @ssh_key ||= SshKey.find_by(id: params[:key_id].split('-').last)
    @user ||= @ssh_key&.user
    @blog = @user.blogs.find_by(repo_name: params[:repo_name])

    if @blog
      render json: { repo_path: @blog.repo_path, user_name: @user.name, allowed: true }
    else
      render json: { allowed: false }
    end
  end
end
