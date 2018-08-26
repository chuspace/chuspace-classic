# frozen_string_literal: true

module AvatarHelper
  def avatar_for(initials:, url: nil, options: {})
    options[:class] = "avatar #{options[:class]}".strip

    unless url.blank?
      image_tag(url, **options)
    else
      options[:class] += ' avatar--initials'
      content_tag(:div, initials, **options)
    end
  end
end
