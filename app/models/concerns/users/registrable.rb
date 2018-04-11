# frozen_string_literal: true

module Users
  module Registrable
    extend ActiveSupport::Concern

    class_methods do
      def from_email(params)
        create!(params)
      end

      def from_github(auth)
        puts auth.inspect
        where(github_uid: auth.uid).first_or_initialize.tap do |user|
          # Required
          user.email = auth.info.email
          user.name = auth.info.name
          user.nickname = auth.info.nickname
          # Profile
          user.bio = auth.extra.raw_info.bio
          user.website = auth.extra.raw_info.html_url
          user.company = auth.extra.raw_info.company
          # Github
          user.github_uid = auth.uid
          user.github_access_token = auth.credentials.token
          # Avatar
          remote_file = RemoteFileToBlobService.new(auth.info.image)
          user.avatar.attach(remote_file.blob)
          user.save!
        end
      end
    end
  end
end
