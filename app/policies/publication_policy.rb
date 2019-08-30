# typed: false
# frozen_string_literal: true

class PublicationPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def edit?
    record.persisted? && user == record.owner
  end

  def destroy?
    edit?
  end

  def show?
    record.persisted?
  end

  def update?
    edit?
  end
end
