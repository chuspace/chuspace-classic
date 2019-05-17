# frozen_string_literal: true

class CreateSshKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :ssh_keys do |t|
      t.string :title
      t.text :key, null: false
      t.index :key, unique: true
      t.string :fingerprint, null: false

      t.bigint :user_id, foreign_key: true, null: false
      t.index :user_id

      t.datetime :last_used
      t.index :last_used

      t.timestamps
    end
  end
end
