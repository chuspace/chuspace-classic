# typed: false
# frozen_string_literal: true

class InvitationPolicy < ApplicationPolicy
  def create?
    record.publication.owner == user
  end

  def accept?
    record.recipient == user
  end
end
