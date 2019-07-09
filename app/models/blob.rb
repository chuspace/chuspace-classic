# typed: ignore
# frozen_string_literal: true

class Blob < ApplicationRecord
  belongs_to :repository
  belongs_to :author, class_name: 'User'
end
