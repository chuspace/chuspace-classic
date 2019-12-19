# typed: strict
# frozen_string_literal: true

class Ahoy::Visit < ApplicationRecord
  self.table_name = 'visits'

  has_many :events, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true
end
