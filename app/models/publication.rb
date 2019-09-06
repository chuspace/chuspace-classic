# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Repoable, AvatarUploader::Attachment.new(:avatar)

  UNLISTED = %w[policy site]

  before_validation :assign_slug, if: -> { name_changed? && !slug_changed? }
  before_validation :add_owning_collaboration, on: :create

  validates_presence_of :name, :slug
  validates_presence_of :description, :avatar, unless: :personal
  validates :name, length: { in: 1..39 }, format: { with: /\A^[a-zA-Z\s]*$\z/i }
  validates :slug, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :description, length: { in: 1..140 }, unless: :personal
  validates_db_uniqueness_of :slug, :name
  validates_db_uniqueness_of :personal, scope: :owner_id
  validate :personal_attribute_should_contain_valid_values

  has_many :posts, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :members, through: :collaborators, class_name: 'User', source: :user
  has_one :owning_collaboration, -> { where(role: 'owner') }, class_name: 'Collaborator', autosave: true, required: true
  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id, counter_cache: true

  scope :personal, -> { where(personal: true) }
  scope :listed, -> { where(personal: nil) }

  delegate :count, to: :members, prefix: true

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

  def add_owning_collaboration
    self.owning_collaboration = build_owning_collaboration(user: owner, publication: self, role: 'owner')
  end

  def personal_attribute_should_contain_valid_values
    errors.add(:personal, :invalid) unless personal || personal.nil?
  end
end
