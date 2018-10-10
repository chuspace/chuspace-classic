# frozen_string_literal: true

class Blog < ApplicationRecord
  STORAGE_DIR = Pathname.new(Rails.root.join('git/repositories'))

  validates :name, :repo_name, :repo_path, presence: true
  validates :repo_name, uniqueness: true

  belongs_to :person
  has_many :posts

  def repo_dir
    STORAGE_DIR.join(repo_name).tap(&:mkpath)
  end
end
