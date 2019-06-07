# frozen_string_literal: true

class CreateBlobs < ActiveRecord::Migration[6.0]
  def change
    create_table :blobs do |t|
      t.string :blob_type, default: 'text/plain', null: false
      t.index :blob_type

      t.string :path
      t.index :path, unique: true

      t.jsonb :blob_data

      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
