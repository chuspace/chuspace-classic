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

  def edit_items(publication, post)
    items = []

    if post&.persisted?
      if allowed_to?(:edit?, post)
        items.push(
          label: 'Edit',
          url: edit_publication_post_path(publication, post),
          active: link_class(edit_publication_post_path(publication, post)),
          options: {}
        )
      end

      if allowed_to?(:publish?, post)
        items.push(
          label: post.publish_label,
          url: publication_post_publish_index_path(publication, post),
          active: link_class(publication_post_publish_index_path(publication, post)),
          options: { css_class: 'button button--active button--slim mr-2' }
        )
      end

      if allowed_to?(:destroy?, post)
        items.push(
          label: 'Delete',
          url: publication_post_path(publication, post),
          active: link_class(publication_post_path(publication, post)),
          link_type: :danger,
          options: {
            css_class: 'button button--danger button--slim', method: :delete, data: { confirm: 'Are you sure?' }
          }
        )
      end

      items.map { |hash| OpenStruct.new(hash) }.freeze
    else
      items
    end
  end
end
