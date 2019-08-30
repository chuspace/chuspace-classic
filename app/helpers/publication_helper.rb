# typed: false
# frozen_string_literal: true

module PublicationHelper
  def publications_items
    Current.user.publications.map do |publication|
      avatar = if publication.personal
        component('avatar', avatar: avatar, gravatar: Current.user.gravatar, variant: :sm)
      else
        component('avatar', avatar: publication.avatar, variant: :sm)
      end

      OpenStruct.new(label: "#{avatar}#{publication.name}".html_safe, url: new_publication_post_path(publication), options: {})
    end
  end
end
