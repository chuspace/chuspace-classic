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

      t.string :repo_name, default: Repository::DEFAULT_NAME, null: false
      t.index %i[repo_name slug], unique: true

      t.string :repo_full_name, null: false
      t.index :repo_full_name, unique: true

      t.string :repo_path, null: false
      t.index :repo_path, unique: true

      t.boolean :personal
      t.index %i[slug personal], unique: true

      t.references :owner, index: true, null: false, foreign_key: { to_table: :users }

      t.string :email, unique: true
      t.string :twitter, unique: true
      t.string :facebook, unique: true

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.timestamps
    end
  end
end
