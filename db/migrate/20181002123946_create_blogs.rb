class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs, id: :uuid do |t|
      t.string :name, null: false, default: 'blog'
      t.citext :repo_name, null: false, default: ''
      t.string :repo_path, null: false
      t.uuid :person_id, foreign_key: true

      t.timestamps
    end

    add_index :blogs, :repo_name, unique: true
    add_index :blogs, :repo_path, unique: true
  end
end
