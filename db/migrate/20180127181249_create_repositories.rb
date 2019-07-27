# typed: ignore
# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories do |t|
      t.string :name, default: Repository::DEFAULT_NAME, null: false
      t.index %i[name author_id], unique: true

      t.string :full_name, null: false
      t.index :full_name, unique: true

      t.string :path, null: false
      t.index :path, unique: true

      t.references :author, index: true, null: false, foreign_key: { to_table: :users }
      t.integer :posts_count, null: false, default: 0

      t.timestamps
    end
  end
end
