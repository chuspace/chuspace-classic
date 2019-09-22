# typed: true
# frozen_string_literal: true

class AddUnlistedToPublications < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :publications, :unlisted, :boolean, default: false
    add_index :publications, :unlisted, algorithm: :concurrently
  end
end
