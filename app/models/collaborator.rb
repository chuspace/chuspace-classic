# typed: strict
# frozen_string_literal: true

class Collaborator < ApplicationRecord
  belongs_to :publication, counter_cache: true
  belongs_to :user

  enum role: { writer: 0, editor: 1, admin: 2 }
end
