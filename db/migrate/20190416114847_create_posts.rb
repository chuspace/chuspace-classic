# typed: ignore
# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :summary

      t.string :slug, null: false
      t.index %i[slug publication_id], unique: true

      t.text :body_html

      t.string :preview_image_data

      t.boolean :featured, index: true
      t.boolean :private, index: true

      t.string :blob_id, index: true
      t.string :blob_path, null: false, index: true
      t.string :commit_sha, null: false, index: true
      t.integer :status, default: 0, null: false, index: true

      t.references :author, index: true, null: false, foreign_key: { to_table: :users }
      t.references :publication, null: false, foreign_key: true
      t.integer :likes_count, null: false, default: 0

      t.string :ancestry
      t.index :ancestry

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.string :canonical_url

      t.datetime :published_at
      t.index :published_at

      t.timestamps
    end
  end
end
