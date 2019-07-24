# typed: ignore
# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
