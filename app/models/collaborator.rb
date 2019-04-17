# frozen_string_literal: true

class Collaborator < ApplicationRecord
  belongs_to :post
  belongs_to :user
end
