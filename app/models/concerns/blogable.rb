# frozen_string_literal: true

module Blogable
  extend ActiveSupport::Concern

  included do
    validates :blog_storage_path, presence: true, uniqueness: true

    before_validation :assign_blog_storage_path, on: :create
    before_create :create_blog_storage
    before_save :rename_blog_storage, if: -> { !new_record? && nickname_changed? }
    after_destroy :destroy_blog_storage

    has_one :default_blog, -> { where(default: true) }, foreign_key: 'author_id', class_name: 'Blog', required: true
    has_many :blogs, foreign_key: 'author_id', dependent: :destroy
  end

  private

  def assign_blog_storage_path
    self.blog_storage_path = Git.config.storage_path.join(nickname)
  end

  def create_blog_storage
    Rails.logger.info "Creating repository storage at #{blog_storage_path} for #{nickname}."
    FileUtils.mkdir_p(blog_storage_path)
  end

  def rename_blog_storage(record)
    new_blog_storage_path = File.join(blog_storage_path, '..', record.nickname)
    Rails.logger.info "Moving repository storage from #{blog_storage_path} to #{new_blog_storage_path} for #{record.nickname}."
    FileUtils.mv(blog_storage_path, new_blog_storage_path)
  end

  def destroy_blog_storage
    Rails.logger.info "Destroying repository storage from #{blog_storage_path}."
    FileUtils.rm_rf(blog_storage_path)
  end
end
