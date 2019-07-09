# typed: ignore
# frozen_string_literal: true

class CreateBlobs < ActiveRecord::Migration[6.0]
  def change
    create_table :blobs do |t|
      t.string :name, null: false
      t.index :name

      t.string :slug, null: false
      t.index %i[slug repository_id], unique: true

      t.string :oid, null: false
      t.index %i[oid repository_id], unique: true

      t.string :path, null: false
      t.index %i[path repository_id], unique: true

      t.string :commit_sha, null: false
      t.boolean :binary, default: false
      t.index :binary

      t.string :mime_type, null: false, default: 'text/markdown'

      t.references :repository, null: false, foreign_key: true
      t.bigint :author_id, foreign_key: true, null: false
      t.index :author_id

      t.timestamps
    end
  end
end
