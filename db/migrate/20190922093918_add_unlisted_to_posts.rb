# typed: true
# frozen_string_literal: true

class AddUnlistedToPosts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :posts, :unlisted, :boolean, default: false
    add_index :posts, :unlisted, algorithm: :concurrently
  end
end
