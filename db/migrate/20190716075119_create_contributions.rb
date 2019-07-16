# typed: true
# frozen_string_literal: true

class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.references :contributor, index: true, null: false, foreign_key: { to_table: :users }
      t.references :post, index: true, null: false, foreign_key: true

      t.string :branch_name, null: false
      t.index :branch_name, unique: true

      t.string :commit_sha, null: false
      t.index :commit_sha

      t.integer :status, default: 0, null: false
      t.index :status

      t.timestamps
    end
  end
end
