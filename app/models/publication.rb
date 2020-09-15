# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Avatarable, Topicable, AvatarUploader::Attachment.new(:avatar)
  extend FriendlyId

  friendly_id :name, use: %i[slugged history], slug_limit: 70

  before_validation :add_owning_collaboration, on: :create

  validates_presence_of :name, :slug
  validates_presence_of :description, :avatar, unless: :personal
  validates :name, length: { in: 1..39 }, format: { with: /\A^[a-zA-Z0-9\s]*$\z/i }
  validates :slug, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :description, length: { in: 1..80 }, unless: :personal
  validates_db_uniqueness_of :slug, :name
  validates_db_uniqueness_of :personal, scope: :owner_id
  validate :personal_attribute_should_contain_valid_values

  validates :website, url: true, allow_blank: true
  validates :twitter, url: { twitter: true }, allow_blank: true

  has_many :posts, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :members, through: :collaborators, class_name: 'User', source: :user
  has_one :owning_collaboration, -> { where(role: 'owner') }, class_name: 'Collaborator', autosave: true, required: true
  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id, counter_cache: true

  scope :personal, -> { where(personal: true) }
  scope :listed, -> { where(unlisted: false) }

  delegate :count, to: :members, prefix: true

  def should_generate_new_friendly_id?
    !slug_changed? && (name_changed? || super)
  end

  private

  def add_owning_collaboration
    self.owning_collaboration = build_owning_collaboration(user: owner, publication: self, role: 'owner')
  end

  def personal_attribute_should_contain_valid_values
    errors.add(:personal, :invalid) unless personal || personal.nil?
  end
end
