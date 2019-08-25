# typed: ignore
# frozen_string_literal: true

class Publication < ApplicationRecord
  include Repoable, AvatarUploader::Attachment.new(:avatar)

  validates_presence_of :name, :slug
  validates_db_uniqueness_of :slug
  validates_db_uniqueness_of :personal, scope: :owner_id
  validate :personal_attribute_should_contain_valid_values

  has_many :posts, dependent: :destroy
  db_belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  private

  def personal_attribute_should_contain_valid_values
    errors.add(:personal, :invalid) unless personal || personal.nil?
  end
end
