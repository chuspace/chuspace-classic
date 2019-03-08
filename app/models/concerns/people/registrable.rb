# frozen_string_literal: true

module People
  module Registrable
    extend ActiveSupport::Concern

    class_methods do
      def from_email(params)
        person = new(params)
        person.blog = build_blog_for(person)
        person
      end

      def from_github(auth)
        where(email: auth.info.email).first_or_initialize.tap do |person|
          # Required
          person.email = auth.info.email
          person.name = auth.info.name
          person.nickname = auth.info.nickname

          # Profile
          person.bio = auth.extra.raw_info.bio
          person.location = auth.extra.raw_info.location
          person.url = auth.extra.raw_info.html_url
          person.company = auth.extra.raw_info.company

          # Github
          person.github_info = auth.info
          person.github_uid = auth.uid
          person.github_nickname = auth.info.nickname
          person.github_access_token = auth.credentials.token

          # Avatar
          remote_file = RemoteFileToBlobService.new(auth.info.image)
          person.avatar.attach(remote_file.to_blob)

          # Blog
          build_blog_for(person)

          person
        end
      end

      private

      def build_blog_for(person)
        return person.blog if person.blog&.persisted?
        person.blog = person.build_blog(name: 'Blog')
      end
    end
  end
end
