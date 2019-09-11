# typed: false
# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  alias_rule :create?, to: :new?
  alias_rule :destroy?, to: :edit?

  def new?
    true
  end

  def edit?
    collaborator ||= record.publication.collaborators.find_by(user: user)
    record.author == user || collaborator && collaborator.role != 'writer'
  end

  def publish?
    edit?
  end

  def show?
    record.published?
  end
end
