class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.uuid :user_id
      t.uuid :repo_id
      t.string :commit
      t.integer :version
      t.string :tags, array: true, default: []
      t.boolean :state
      t.datetime :published_at

      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :state
    add_index :posts, :published_at
    add_index :posts, :slug, unique: true
  end
end
