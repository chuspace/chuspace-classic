class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      t.string :name, null: false, default: 'Blog'
      t.string :slug, null: false, default: 'blog'
      t.references :person, foreign_key: true

      t.timestamps
    end

    add_index :blogs, %i[slug person_id], unique: true
  end
end
