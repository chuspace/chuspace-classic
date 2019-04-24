class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      # Content
      t.string :name, null: false
      t.citext :slug, null: false
      t.text :introduction

      # Author
      t.bigint :author_id, foreign_key: true
      t.integer :status, default: 0, null: false

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
    add_index :blogs, %i[slug author_id], unique: true

    # Counter indexes
    add_index :blogs, :posts_count
  end
end
