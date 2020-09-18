# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, Avatarable, AvatarUploader::Attachment.new(:avatar)

  encrypts :email, :provider_token, :provider_secret
  blind_index :email

  before_validation :build_default_publication, on: :create

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email_bidx
  validates :name, :nickname, :name, presence: true
  validates_db_uniqueness_of :nickname
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validate :should_have_a_default_publication

  enum provider: { github: 'github', gitlab: 'gitlab' }
  has_person_name

  has_many :likes, dependent: :destroy
  has_many :visits, class_name: 'Ahoy::Visit', dependent: :delete_all
  has_many :events, class_name: 'Ahoy::Event', dependent: :delete_all
  has_many :publications, class_name: 'Publication', foreign_key: 'owner_id', autosave: true
  has_many :posts, foreign_key: 'author_id'
  has_many :drafts, -> { where(status: :draft) }, class_name: 'Post', foreign_key: 'author_id'

  def to_param
    nickname
  end

  private

  def build_default_publication
    publications.build(name: name, slug: nickname, owner: self)
  end

  def should_have_a_default_publication
    errors.add(:publication, :invalid) if publication.blank?
  end
end
