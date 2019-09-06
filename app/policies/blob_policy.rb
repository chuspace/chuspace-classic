# typed: true
# frozen_string_literal: true

class BlobPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    true
  end

  def show?
    true
  end
end
