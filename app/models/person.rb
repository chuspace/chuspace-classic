# frozen_string_literal: true

class Person < ApplicationRecord
  include People::Registrable

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true,
            uniqueness: true,
            length: { in: 1..39 },
            format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_secure_token :auth_token
  has_many :ssh_keys, dependent: :destroy

  before_validation :normalize_email_and_nickname
  before_create :create_git_repository
  before_save :mv_git_repository, if: -> { !new_record? && nickname_changed? }
  before_destroy :remove_git_repository

  store_accessor :github_info, :github_nickname, :github_uid, :github_access_token

  delegate :repo_exists?, to: :repo

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def repo
    Git::Repository.new(author_nickname: nickname)
  end

  private

  def normalize_email_and_nickname
    self.email = self.email&.downcase&.strip
    self.nickname = self.nickname&.downcase&.strip
  end

  def create_git_repository
    Git::Repository.new(author_nickname: nickname).create
  end

  def rename_git_repository
    new_path = Git::Repository.new(author_nickname: nickname).path
    Git::Repository.new(author_nickname: nickname_was).rename(new_path)
  end

  def destroy_git_repository
    Git::Repository.new(author_nickname: nickname).destroy
  end
end
