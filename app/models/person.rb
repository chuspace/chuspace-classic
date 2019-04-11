# frozen_string_literal: true

class Person < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true,
            uniqueness: true,
            length: { in: 1..39 },
            format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_secure_token :auth_token
  has_many         :ssh_keys, dependent: :destroy

  before_validation :normalize_email_and_nickname
  before_create     :create_blog_repository
  before_save       :mv_blog_repository, if: -> { !new_record? && nickname_changed? }
  before_destroy    :remove_blog_repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def blog
    Git::Repository.new(author_nickname: nickname)
  end

  def posts(status: 'published')
    all_posts.select { |post| post.status == status }
  end

  def all_posts
    blog.blobs.map do |blob|
      next if blob.binary?

      Post.initialize_from_blob(blob)
    end.compact
  end

  private

  def normalize_email_and_nickname
    self.email    = self.email&.downcase&.strip
    self.nickname = self.nickname&.downcase&.strip
  end

  def create_blog_repository
    Git::Repository.new(author_nickname: nickname).create
  end

  def rename_blog_repository
    new_path = Git::Repository.new(author_nickname: nickname).path
    Git::Repository.new(author_nickname: nickname_was).rename(new_path)
  end

  def destroy_blog_repository
    Git::Repository.new(author_nickname: nickname).destroy
  end
end
