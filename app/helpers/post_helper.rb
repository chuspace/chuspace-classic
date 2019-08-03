# typed: false
# frozen_string_literal: true

module PostHelper
  def post_header(post)
    partial_path = case params[:controller]
                   when 'posts' then "posts/header/#{params[:action]}"
                   when 'posts/publish' then 'posts/header/edit'
    end

    render partial: partial_path, locals: { post: post }
  end
end
