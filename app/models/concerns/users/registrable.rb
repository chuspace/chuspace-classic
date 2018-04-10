# frozen_string_literal: true

module Users
  module Registrable
    extend ActiveSupport::Concern

    class_methods do
      def from_email(params)
        create!(params)
      end

      def from_github(auth)
        where(uid: auth.github_uid).first_or_initialize.tap do |user|
          user.email = auth.info.email
          user.name = auth.info.name
          user.username = auth.info.nickname
          user.github_uid = auth.uid
          user.github_access_token = auth.credentials.token
          remote_file = RemoteFileToBlobService.new(auth.info.image)
          user.avatar.attach(remote_file.blob)
          user.save!
        end
      end
    end
  end
end
