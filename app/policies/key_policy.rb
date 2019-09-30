# typed: false
# frozen_string_literal: true

class KeyPolicy < ApplicationPolicy
  def destroy?
    user == record.user
  end
end
