# frozen_string_literal: true

class Blog < ApplicationRecord
  STORAGE_DIR = Pathname.new(Rails.root.join('git-storage'))

  validates :name, :repo_name, presence: true
  validates :repo_name, uniqueness: true

  before_create :create_blog_repository

  belongs_to :person
  has_many :posts

  def repo_path
    STORAGE_DIR.join(repo_name).tap(&:mkpath).to_s
  end

  private

  def create_blog_repository
    MobiusClient.new.add_repository(repo_name)
  end
end
