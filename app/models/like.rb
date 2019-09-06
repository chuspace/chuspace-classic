# typed: strict
# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :post, counter_cache: true, touch: true
  belongs_to :user
  validates_db_uniqueness_of :post_id, scope: :user_id
end
