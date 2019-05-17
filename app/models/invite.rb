# frozen_string_literal: true

class Invite < ApplicationRecord
  include AASM

  validates :email, presence: true, uniqueness: true, email: true
  validates :code, uniqueness: true

  has_secure_token :code

  after_create_commit :notify_invitee
  after_update_commit :send_rsvp, if: :approved?

  aasm column: :status do
    state :invited, initial: true
    state :approved, :accepted

    event :approve do
      transitions from: :invited, to: :approved
    end

    event :accept do
      transitions from: :approved, to: :accepted
    end
  end

  private

  def notify_invitee
    InviteMailer.with(invite: self).notify_invitee.deliver_later
  end

  def send_rsvp
    InviteMailer.with(invite: self).send_rsvp.deliver_later
  end
end
