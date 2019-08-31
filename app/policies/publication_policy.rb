# typed: false
# frozen_string_literal: true

class PublicationPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def show?
    true
  end

  def index?
    record.owner
  end

  def edit?
    user == record.owner
  end

  def destroy?
    edit?
  end

  def update?
    edit?
  end

  relation_scope { |relation| relation.where(owner: user) }
end
