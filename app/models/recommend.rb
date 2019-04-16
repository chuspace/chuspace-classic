# frozen_string_literal: true

class Recommend < ApplicationRecord
  belongs_to :post
  belongs_to :owner, class_name: 'User'
end
