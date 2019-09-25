# typed: true
# frozen_string_literal: true

class AddFeaturedToPosts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :posts, :featured, :boolean
    add_index :posts, :featured, algorithm: :concurrently
  end
end
