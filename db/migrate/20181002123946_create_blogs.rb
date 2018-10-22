class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      t.string :name, null: false, default: 'blog'
      t.citext :repo_name, null: false, default: ''
      t.references :person, foreign_key: true

      t.timestamps
    end

    add_index :blogs, :repo_name, unique: true
  end
end
