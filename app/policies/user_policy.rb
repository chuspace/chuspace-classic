# typed: false
# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def show?
    true
  end

  def update?
    user == record
  end

  def edit?
    user == record
  end

  def destroy?
    edit?
  end
end
