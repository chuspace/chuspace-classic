# frozen_string_literal: true

class Blog < ApplicationRecord
  include Sluggable
  sluggable source: :name

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :person_id }

  before_create :create_git_repository

  belongs_to :person
  has_many :posts

  def git_repo_full_path
    Mobius.config.git_storage_pathname.join(repo_path).tap(&:mkpath).to_s
  end

  def git_repo_path
    "#{person.nickname}/#{repo_name}".freeze
  end

  def git_repo_name
    "#{slug}.git".freeze
  end

  private

  def create_git_repository
    MobiusClient.new.add_repository(slug)
  end
end
