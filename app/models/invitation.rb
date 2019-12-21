# typed: false
# frozen_string_literal: true

class Invitation < ApplicationRecord
  db_belongs_to :publication
  db_belongs_to :sender, class_name: 'User', foreign_key: :sender_id

  validates :identifier, :role, presence: true
  validates :identifier, presence: true, email: true, if: -> { recipient.blank? }
  validates_db_uniqueness_of :identifier, scope: :publication_id
  validates_db_uniqueness_of :code
  validate :check_if_recipient_can_be_invited

  after_create :send_email

  enum status: { pending: 0, joined: 1 }
  enum role: { writer: 0, editor: 1, admin: 2 }

  has_secure_token :code

  def recipient
    @recipient ||= User.find_by_email(identifier) || User.find_by_nickname(identifier)
  end

  def recipient_email
    recipient.blank? ? identifier : recipient.email
  end

  private

  def check_if_recipient_can_be_invited
    errors.add(:identifier, 'Already a member') if publication.members.include?(recipient)
  end

  def send_email
    UserMailer.with(invitation: self).invite.deliver_later
  end
end
