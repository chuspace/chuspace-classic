class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false

      # Content
      t.text :excerpt
      t.text :body
      t.bigint :author_id, foreign_key: true, null: false
      t.datetime :published_at

      # Tree
      t.string :ancestry

      # Flags
      t.integer :status, default: 0, null: false
      t.boolean :premium, default: false, null: false

      # Git related
      t.string :blob_id, null: false
      t.string :commit_sha, null: false

      # Counters
      t.bigint :comments_count, default: 0
      t.bigint :recommends_count, default: 0
      t.bigint :bookmarks_count, default: 0

      t.timestamps
    end

    add_index :posts, :author_id
    add_index :posts, :published_at
    add_index :posts, :status
    add_index :posts, :ancestry
    add_index :posts, :premium
    add_index :posts, :blob_id
    add_index :posts, :commit_sha
    add_index :posts, :slug, unique: true
  end
end
