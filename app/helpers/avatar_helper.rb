# frozen_string_literal: true

module AvatarHelper
  def avatar_for(user:, **options)
    options[:class] = "avatar #{options[:class]}".strip
    size_props = sizes.dig(options[:size] || :xs)
    options[:size] = size_props[:size]

    url = url_for(user.avatar.variant(resize_to_fit: [options[:size], options[:size]]))

    if url.blank?
      options[:class] += " avatar--initials #{size[:class]}"
      content_tag(:div, user.initials, options.except(:size))
    else
      image_tag(url, **options)
    end
  end

  private
    def sizes
      {
        xs: {
          size: 50,
          class: 'avatar-xs'
        },
        sm: {
          size: 100,
          class: 'avatar-sm',
        },
        md: {
          size: 150,
          class: 'avatar-md'
        },
        lg: {
          size: 200,
          class: 'avatar-lg'
        }
      }.with_indifferent_access.freeze
    end
end
