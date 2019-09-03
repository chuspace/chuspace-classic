# typed: false
# frozen_string_literal: true

class PublicationPolicy < ApplicationPolicy
  alias_rule :destroy?, :update?, :invite?, to: :edit?
  alias_rule :create?, :show?, :index?, to: :new?

  def new?
    true
  end

  def edit?
    user == record.owner || record.collaborators.where(role: :admin, user: user).exists?
  end

  relation_scope { |relation| relation.joins(:members).where(collaborators: { user_id: user.id }) }
end
