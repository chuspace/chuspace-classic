# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      # Content
      t.string :title,
                        null: false
      t.citext :slug, null: false
      t.text :excerpt
      t.text :body

      # Associations
      t.bigint :author_id, foreign_key: true, null: false
      t.bigint :blog_id, foreign_key: true, null: false
      t.datetime :published_at
      t.integer :status, default: 0, null: false

      # Tree
      t.string :ancestry

      # Git
      t.string :blob_id, null: false

      t.timestamps
    end

    # Indexes
    add_index :posts, :published_at
    add_index :posts, :ancestry
    add_index :posts, :status

    add_index :posts, :blob_id, unique: true
    add_index :posts, %i[slug blog_id author_id], unique: true
  end
end
