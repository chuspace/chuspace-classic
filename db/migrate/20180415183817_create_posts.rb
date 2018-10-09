class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title
      t.citext :slug, null: false
      t.text :body

      t.uuid :person_id, foreign_key: true
      t.string :tags, array: true, default: []
      t.integer :status, default: 0, null: false

      t.datetime :published_at
      t.timestamps
    end

    add_index :posts, :status
    add_index :posts, :published_at
    add_index :posts, :slug, unique: true
  end
end
