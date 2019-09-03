# typed: false
# frozen_string_literal: true

class KeyPolicy < ApplicationPolicy
  alias_rule :create?, :index?, to: :new?

  def new?
    true
  end

  def destroy?
    user == record.user
  end
end
