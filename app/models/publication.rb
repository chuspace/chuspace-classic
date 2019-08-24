# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Repoable, AvatarUploader::Attachment.new(:avatar)

  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_one_repo :nickname, :owner
end
