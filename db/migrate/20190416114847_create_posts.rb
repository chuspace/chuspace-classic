# typed: ignore
# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :subtitle

      t.string :slug, null: false
      t.index %i[slug repository_id]

      t.text :excerpt
      t.text :body

      t.bigint :author_id, foreign_key: true, null: false
      t.index :author_id

      t.string :blob_path
      t.index %i[blob_path repository_id], unique: true

      t.references :repository, foreign_key: true, null: false

      t.string :ancestry
      t.index :ancestry

      t.integer :status, default: 0, null: false
      t.index :status

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.datetime :published_at
      t.index :published_at

      t.timestamps
    end
  end
end
