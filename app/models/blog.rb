# frozen_string_literal: true

class Blog < ApplicationRecord
  include Sluggable
  sluggable source: :name

  STORAGE_DIR = Pathname.new(Rails.root.join('git-storage'))

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :person_id }

  before_create :create_blog_repository

  belongs_to :person
  has_many :posts

  def repo_path
    STORAGE_DIR.join(slug).tap(&:mkpath).to_s
  end

  private

  def create_blog_repository
    MobiusClient.new.add_repository(slug)
  end
end
