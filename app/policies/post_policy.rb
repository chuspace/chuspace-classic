# typed: false
# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  alias_rule :create?, to: :new?
  alias_rule :destroy?, to: :edit?

  def new?
    true
  end

  def edit?
    collaborator ||= post.publication.collaborators.find_by(user: user)
    post.author == user || collaborator && collaborator.role != Collaborator::WRITER_ROLE
  end

  def publish?
    edit?
  end

  def republish?
    edit? && record.outdated?
  end

  def contribute?
    !edit?
  end

  def show?
    true
  end
end
