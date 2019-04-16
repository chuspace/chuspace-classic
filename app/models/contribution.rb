class Contribution < ApplicationRecord
  belongs_to :contributor, class_name: 'User'
  belongs_to :post

  enum status: { created: 0, merged: 0, archived: 1 }
end
