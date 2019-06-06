# frozen_string_literal: true

class CreateBlobs < ActiveRecord::Migration[6.0]
  def change
    create_table :blobs do |t|
      t.text :name

      t.text :path
      t.index :path, unique: true

      t.text :blob_data

      t.boolean :binary, default: false
      t.index :binary

      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
