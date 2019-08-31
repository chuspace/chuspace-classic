# typed: false
# frozen_string_literal: true

class Posts::PublishPolicy < ApplicationPolicy
  authorize :user, :post
  alias_rule :create?, to: :index?

  def index?
    post.author == user && post.outdated?
  end
end
