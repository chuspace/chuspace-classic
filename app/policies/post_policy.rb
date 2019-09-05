# typed: false
# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  alias_rule :create?, to: :new?
  alias_rule :destroy?, to: :edit?

  def new?
    true
  end

  def edit?
    record.publication.members.include?(user)
  end

  def publish?
    edit? && record.outdated?
  end

  def show?
    record.published?
  end
end
