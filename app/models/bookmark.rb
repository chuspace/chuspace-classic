# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :post
end
