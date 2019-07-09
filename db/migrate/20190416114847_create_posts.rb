# typed: ignore
# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :summary

      t.string :slug, null: false
      t.index %i[slug author_id]

      t.text :body

      t.references :blob, foreign_key: true, null: false
      t.bigint :author_id, foreign_key: true, null: false
      t.index :author_id

      t.string :ancestry
      t.index :ancestry

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
