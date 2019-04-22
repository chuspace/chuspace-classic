class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      # Content
      t.string :name,
                        null: false
      t.citext :slug, null: false
      t.text :introduction

      # Author
      t.bigint :author_id, foreign_key: true

      # Flags
      t.string :visibility, default: 'public'
      t.boolean :default, null: false, default: false

      # Git
      t.string :version

      # Counters
      t.bigint :posts_count, null: false, default: 0

      t.timestamps
    end

    # Indexes
    add_index :blogs, :author_id
    add_index :blogs, :repo_name
    add_index :blogs, :repo_path
    add_index :blogs, :slug, unique: true

    # Counter indexes
    add_index :blogs, :posts_count
  end
end
