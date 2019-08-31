# typed: ignore
# frozen_string_literal: true

class CreatePublications < ActiveRecord::Migration[6.0]
  def change
    create_table :publications do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.string :slug, null: false
      t.index :slug, unique: true

      t.text :description
      t.jsonb :avatar_data

      t.string :repo_name, null: false
      t.index :repo_name, unique: true

      t.string :repo_path, null: false
      t.index :repo_path, unique: true

      t.boolean :personal
      t.index %i[owner_id personal], unique: true
      t.boolean :internal, default: false, null: false

      t.references :owner, index: true, null: false, foreign_key: { to_table: :users }
      t.string :twitter

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.integer :posts_count, null: false, default: 0
      t.integer :collaborators_count, null: false, default: 0

      t.timestamps
    end
  end
end
