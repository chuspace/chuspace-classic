# typed: false
# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  alias_rule :create?, :show?, to: :new?
  alias_rule :edit?, :destroy?, :drafts?, to: :update?

  def new?
    true
  end

  def update?
    user == record
  end
end
