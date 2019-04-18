# frozen_string_literal: true

module AvatarHelper
  def avatar_for(user:, **options)
    variant = variants.dig(options[:size].to_sym || :xs)
    options[:size] = variant[:size]

    if user.avatar.blank?
      options[:class] =
        "avatar avatar-initials #{variant[:class]} #{options[:class]}".strip
      content_tag(:div, user.initials, options.except(:size))
    else
      url =
        url_for(
          user.avatar.variant(resize_to_fit: [variant[:size], variant[:size]])
        )
      options[:class] = "avatar #{options[:class]}".strip
      image_tag(url, options)
    end
  end

  private
  def variants
    {
      xs: { size: 40, class: 'avatar-xs' },
      sm: { size: 80, class: 'avatar-sm' },
      md: { size: 120, class: 'avatar-md' },
      lg: { size: 150, class: 'avatar-lg' }
    }.freeze
  end
end
