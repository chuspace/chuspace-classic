class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      # Content
      t.string :name, null: false
      t.string :name_with_author, null: false
      t.citext :slug, null: false
      t.text :introduction

      # Author
      t.bigint :author_id, foreign_key: true
      t.integer :status, default: 0, null: false

      # Git repo
      t.string :repo_name, null: false
      t.string :repo_path, null: false

      # Flags
      t.string :visibility, default: 'public'
      t.boolean :default, null: false, default: false

      # Counters
      t.bigint :posts_count, null: false, default: 0

      t.timestamps
    end

    # Indexes
    add_index :blogs, :author_id
    add_index :blogs, :status
    add_index :blogs, :slug

    add_index :blogs, :name_with_author, unique: true
    add_index :blogs, :repo_name, unique: true
    add_index :blogs, :repo_path, unique: true

    # Counter indexes
    add_index :blogs, :posts_count
  end
end
