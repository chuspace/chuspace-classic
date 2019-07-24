# typed: ignore
# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :summary

      t.string :slug, null: false
      t.index %i[slug repository_id], unique: true

      t.text :body_html

      t.string :blob_id
      t.string :blob_path, null: false
      t.index %i[blob_path repository_id], unique: true

      t.integer :status, default: 0, null: false
      t.index :status

      t.references :author, index: true, null: false, foreign_key: { to_table: :users }
      t.references :repository, null: false, foreign_key: true

      t.string :ancestry
      t.index :ancestry

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.datetime :published_at
      t.index :published_at

      t.timestamps
    end
  end
end
