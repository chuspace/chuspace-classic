# frozen_string_literal: true

class Blog < ApplicationRecord
  include GitRepo, Sluggable
  sluggable :name

  validates :name, :slug, :name_with_author, :repo_name, :repo_path, presence: true
  validates_uniqueness_of :name_with_author

  enum status: { draft: 0, published: 1, archived: 2 }

  belongs_to :author, class_name: 'User'
  has_many :posts
end
