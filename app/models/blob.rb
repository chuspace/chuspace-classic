# typed: ignore
# frozen_string_literal: true

class Blob < ApplicationRecord
  belongs_to :repository
  belongs_to :author, class_name: 'User'

  validates_presence_of :name, :slug, :oid, :path

  validates_uniqueness_of :slug, scope: %i[repository_id]
  validates_uniqueness_of :oid, scope: %i[repository_id]
  validates_uniqueness_of :path, scope: %i[repository_id]

  validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }

  delegate :content, to: :git_blob

  def git_blob
    @git_blob ||= repository.rugged.blob_at(repository.commit_sha, path)
  end

  def to_param
    slug
  end

  def title
    @title ||= FastMarkdown.title(content)
  end
end
