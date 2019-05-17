# frozen_string_literal: true

class Blog < ApplicationRecord
  include HasGitRepo

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name, :slug, :repo_name, :repo_path, :status, :author_id
  validates :repo_path, uniqueness: true
  validates_uniqueness_of :repo_name, scope: :author_id
  validates_uniqueness_of :slug, scope: :author_id

  enum status: { published: 0, unpublished: 1, archived: 2 }

  belongs_to :author, class_name: 'User'
  has_many :posts

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
