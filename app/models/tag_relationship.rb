# frozen_string_literal: true

class TagRelationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :tag
end
