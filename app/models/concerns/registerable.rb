# frozen_string_literal: true

module Registerable
  extend ActiveSupport::Concern

  class_methods do
    def from_email(params)
      create!(params)
    end

    def from_omniauth(auth)
      where(uid: auth.uid).first_or_initialize.tap do |user|
        user.email = auth.info.email
        user.uid = auth.uid
        user.name = auth.info.name
        user.username = auth.info.nickname
        user.access_token = auth.credentials.token
        remote_file = RemoteFileToBlobService.new(auth.info.image)
        user.avatar.attach(remote_file.blob)
        user.save!
      end
    end
  end
end
