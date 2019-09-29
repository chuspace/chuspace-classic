# typed: false
# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  alias_rule :create?, to: :new?
  alias_rule :destroy?, to: :edit?

  def new?
    true
  end

  def edit?
    record.can_edit?(user: user)
  end

  def publish?
    edit?
  end

  def republish?
    edit? && record.outdated?
  end

  def contribute?
    !edit?
  end

  def show?
    true
  end
end
