# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Repoable, AvatarUploader::Attachment.new(:avatar)

  before_validation :assign_slug, if: :name_changed?

  validates_presence_of :name, :slug
  validates_presence_of :description, :avatar, unless: -> { personal || internal }
  validates :name, length: { in: 1..39 }, format: { with: /\A^[a-zA-Z\s]*$\z/i }
  validates :slug, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :description, length: { in: 1..140 }, unless: -> { personal || internal }
  validates_db_uniqueness_of :slug
  validates_db_uniqueness_of :personal, scope: :owner_id
  validate :personal_attribute_should_contain_valid_values

  has_many :posts, dependent: :destroy
  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  scope :internal, -> { where(internal: true) }
  scope :personal, -> { where(personal: true) }
  scope :listed, -> { where.not(internal: true).where(personal: nil) }

  def to_param
    slug
  end

  def topics_list
    topics&.join(',')
  end

  private

  def assign_slug
    self.slug = name&.to_slug&.to_ascii&.normalize&.to_s
  end

  def personal_attribute_should_contain_valid_values
    errors.add(:personal, :invalid) unless personal || personal.nil?
  end
end
