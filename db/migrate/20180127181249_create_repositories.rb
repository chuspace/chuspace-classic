# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories do |t|
      t.string :name, default: Repository::DEFAULT_NAME, null: false
      t.index [:name, :author_id], unique: true

      t.string :path, null: false
      t.index :path, unique: true

      t.string :commit_sha, null: false
      t.index :commit_sha, unique: true

      t.bigint :author_id, null: false, foreign_key: true
      t.index :author_id

      t.timestamps
    end
  end
end
