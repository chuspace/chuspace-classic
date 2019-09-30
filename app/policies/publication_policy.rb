# typed: false
# frozen_string_literal: true

class PublicationPolicy < ApplicationPolicy
  alias_rule :update?, :invite?, :drafts?, to: :edit?
  alias_rule :create?, :show?, :index?, to: :new?

  def new?
    true
  end

  def edit?
    user == record.owner || record.members.where.not(role: Collaborator::WRITER_ROLE).include?(user)
  end

  def publish?
    user == record.owner || record.members.include?(user)
  end

  def destroy?
    user == record.owner
  end

  relation_scope { |relation| relation.joins(:members).where(collaborators: { user_id: user.id }) }
end
