class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.citext :slug, null: false

      # Content
      t.text :excerpt
      t.text :body
      t.bigint :author_id, foreign_key: true, null: false
      t.bigint :blog_id, foreign_key: true, null: false
      t.datetime :published_at
      t.integer :status, default: 0, null: false

      # Tree
      t.string :ancestry

      # Flags
      t.string :visibility, default: 'public'
      t.boolean :premium, default: false, null: false

      # Git
      t.string :blob_id, null: false

      # Counters
      t.bigint :comments_count, default: 0
      t.bigint :recommends_count, default: 0
      t.bigint :bookmarks_count, default: 0

      t.timestamps
    end

    # Indexes
    add_index :posts, :author_id
    add_index :posts, :blog_id
    add_index :posts, :published_at
    add_index :posts, :visibility
    add_index :posts, :ancestry
    add_index :posts, :premium
    add_index :posts, :blob_id
    add_index :posts, :status
    add_index :posts, [:slug, :blog_id], unique: true

    # Counter indexes
    add_index :posts, :comments_count
    add_index :posts, :recommends_count
    add_index :posts, :bookmarks_count
  end
end
