# typed: false
# frozen_string_literal: true

class CollaboratorPolicy < ApplicationPolicy
  alias_rule :destroy?, to: :update?

  def update?
    user == record.publication.owner && !record.owner?
  end
end
