# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :comment
end
