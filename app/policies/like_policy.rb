# typed: false
# frozen_string_literal: true

class LikePolicy < ApplicationPolicy
  def create?
    user != record.post.author
  end
end
