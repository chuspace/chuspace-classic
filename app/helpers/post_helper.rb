# typed: false
# frozen_string_literal: true

module PostHelper
  def post_header(post)
    partial_path =
      case params[:controller]
      when 'posts'
        "posts/header/#{params[:action]}"
      when 'posts/publish'
        'posts/header/edit'
      end

    render partial: partial_path, locals: { post: post, publication: post.publication }
  end
end
