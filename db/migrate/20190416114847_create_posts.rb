# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.citext :slug, null: false
      t.text :excerpt
      t.text :body

      t.bigint :author_id, foreign_key: true, null: false
      t.bigint :blog_id, foreign_key: true, null: false
      t.index %i[slug blog_id author_id], unique: true

      t.datetime :published_at
      t.index :published_at

      t.integer :status, default: 0, null: false
      t.index :status

      t.string :ancestry
      t.index :ancestry

      t.string :blob_id, null: false
      t.index :blob_id, unique: true

      t.timestamps
    end
  end
end
