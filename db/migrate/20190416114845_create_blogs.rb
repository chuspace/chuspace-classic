class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :introduction
      t.bigint :author_id, foreign_key: true
      t.integer :status, null: false, default: 0
      t.boolean :premium, null: false, default: false
      t.string :version
      t.string :repo_name, null: false
      t.string :repo_path, null: false
      t.string :commit_sha, null: false

      t.timestamps
    end

    add_index :blogs, :author_id
    add_index :blogs, :repo_name
    add_index :blogs, :repo_path
    add_index :blogs, :commit_sha
    add_index :blogs, :slug, unique: true
  end
end
