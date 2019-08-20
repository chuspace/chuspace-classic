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

  def edit_items(post)
    items = []

    if policy(post).publish?
      items.push(
        label:  post.publish_label,
        url: post_publish_index_path(post),
        active: link_class(post_publish_index_path(post)),
        options: { css_class: 'button button--active button--slim mr-2' }
      )
    end

    if policy(post).destroy?
      items.push(
        label:  'Delete',
        url: link_class(post_path(post)),
        active: true,
        link_type: :danger,
        options: { css_class: 'button button--danger button--slim', method: :delete, data: { confirm: 'Are you sure?' } }
      )
    end

    items.map { |hash| OpenStruct.new(hash) }.freeze
  end
end
