# typed: false
# frozen_string_literal: true

module PublicationHelper
  def publications_items
    items =
      Current.user.publications.limit(5).order(:id).map do |publication|
        avatar =
          if publication.personal
            component(
              'avatar',
              avatar_url: Current.user.avatar_url, gravatar_url: Current.user.gravatar_url, variant: :xs
            )
          else
            component('avatar', avatar_url: publication.avatar_url, variant: :xs)
          end

        OpenStruct.new(
          label: "#{avatar} Write post".html_safe, url: new_publication_post_path(publication), options: {}
        )
      end

    items.push(OpenStruct.new(label: 'New publication'.html_safe, url: new_publication_path, options: {}))
  end

  def collaborator_actions(publication, collaborator)
    items =
      Collaborator.roles.except(:owner).map do |role, _|
        next if collaborator.role == role

        OpenStruct.new(
          label: "Make #{role}",
          url: publication_person_path(publication, collaborator, role: role),
          options: { method: :patch, remote: true }
        )
      end.compact

    items <<
      OpenStruct.new(
        label: "Remove from #{publication.slug}",
        url: publication_person_path(publication, collaborator),
        options: { method: :delete, remote: true, 'data-confirm': 'Are you sure?' }
      )
  end
end
