# typed: true
# frozen_string_literal: true

class Collaborator < ApplicationRecord
  belongs_to :publication, counter_cache: true, autosave: true
  belongs_to :user

  enum role: { writer: 0, editor: 1, admin: 2, owner: 3 }
  ROLES = roles.map { |k, _| [k.titlecase, k] unless k == 'owner' }.compact.freeze
  DEFAULT_ROLE = ROLES.first
end
