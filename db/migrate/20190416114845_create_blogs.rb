# frozen_string_literal: true

class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.index %i[author_id slug], unique: true
      t.text :introduction

      t.bigint :author_id, foreign_key: true
      t.integer :status, default: 0, null: false
      t.index :status

      t.string :repo_name, null: false
      t.index %i[author_id repo_name], unique: true
      t.string :repo_path, null: false
      t.index :repo_path, unique: true

      t.boolean :default, null: false, default: false
      t.index :default

      t.bigint :posts_count, null: false, default: 0

      t.timestamps
    end
  end
end
