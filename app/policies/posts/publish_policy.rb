# typed: false
# frozen_string_literal: true

class Posts::PublishPolicy < ApplicationPolicy
  authorize :user, :post
  alias_rule :create?, to: :index?

  def index?
    post.can_edit?(user: user)
  end
end
