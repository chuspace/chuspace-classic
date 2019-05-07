# frozen_string_literal: true

class PostValidationsController < ActionController::Metal
  include AbstractController::Rendering
  include ActionController::Renderers::All
  include ActionController::MimeResponds

  def create
    @ssh_key ||= SshKey.find_by(id: params[:key_id].split('-').last)
    @user ||= @ssh_key&.user
    @blog = @user.blogs.find_by(repo_name: params[:repo_name])

    frontmatter_attrs = YAML.safe_load(params[:markdown]).deep_symbolize_keys!

    post = Post.find_or_initialize_by(author: @user, blog: @blog, slug: frontmatter_attrs[:slug])
    post.assign_attributes(frontmatter_attrs)

    render json: { valid: post.valid?, errors: post.api_validation_errors }
  end
end
