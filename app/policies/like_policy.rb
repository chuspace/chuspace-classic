# typed: false
# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  def create?
    true
  end
end
