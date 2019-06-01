# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false

      t.text :excerpt
      t.text :body

      t.bigint :author_id, foreign_key: true, null: false
      t.index :author_id

      t.bigint :repository_id, foreign_key: true, null: false
      t.index :repository_id

      t.string :ancestry
      t.index :ancestry

      t.string :blob_name, null: false
      t.index %i[blob_name repository_id], unique: true

      t.integer :status, default: 0, null: false
      t.index :status

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.datetime :published_at
      t.index :published_at

      t.timestamps
    end
  end
end
