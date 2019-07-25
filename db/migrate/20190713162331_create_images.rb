# typed: ignore
# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :name
      t.index %i[name repository_id], unique: true

      t.string :blob_path
      t.index :blob_path, unique: true

      t.references :repository, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
