# typed: ignore
# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :keys do |t|
      t.string :title
      t.text :key, null: false
      t.index :key, unique: true
      t.string :fingerprint, null: false
      t.index :fingerprint, unique: true

      t.references :user, foreign_key: true, null: false

      t.datetime :last_used
      t.index :last_used

      t.timestamps
    end
  end
end
