class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.citext :slug, null: false

      # Content
      t.text :excerpt
      t.text :body
      t.bigint :author_id, foreign_key: true, null: false
      t.datetime :published_at

      # Tree
      t.string :ancestry

      # Flags
      t.boolean :visibility, null: false, default: 0
      t.boolean :premium, default: false, null: false

      # Git
      t.string :blob_id, null: false
      t.string :commit_sha, null: false

      # Counters
      t.bigint :comments_count, default: 0
      t.bigint :recommends_count, default: 0
      t.bigint :bookmarks_count, default: 0

      t.timestamps
    end

    # Indexes
    add_index :posts, :author_id
    add_index :posts, :published_at
    add_index :posts, :visibility
    add_index :posts, :ancestry
    add_index :posts, :premium
    add_index :posts, :blob_id
    add_index :posts, :commit_sha
    add_index :posts, :slug, unique: true

    # Counter indexes
    add_index :posts, :comments_count
    add_index :posts, :recommends_count
    add_index :posts, :bookmarks_count
  end
end
