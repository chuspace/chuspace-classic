# typed: false
# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def edit?
    record.persisted? && user == record.author
  end

  def destroy?
    edit?
  end

  def publish?
    edit? && record.outdated?
  end

  def show?
    record.published?
  end
end
