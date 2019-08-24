# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Repoable, AvatarUploader::Attachment.new(:avatar)

  validates_presence_of :name, :slug
  validates_db_uniqueness_of :slug
  validates_db_uniqueness_of :personal, scope: :slug

  has_many :posts, dependent: :destroy
  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  def drafts
    published_blob_paths ||= posts.pluck(:blob_path)
    repository.blobs.select { |blob| published_blob_paths.exclude?(blob.path) && blob.post? }
  end
end
