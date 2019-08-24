# typed: true
# frozen_string_literal: true

class CreatePublications < ActiveRecord::Migration[6.0]
  def change
    create_table :publications do |t|
      t.string :name
      t.index :name, unique: true
      t.string :slug
      t.index :slug, unique: true

      t.text :description
      t.jsonb :avatar_data

      t.references :owner, index: true, null: false, foreign_key: { to_table: :users }

      t.string :email, unique: true
      t.string :twitter, unique: true
      t.string :facebook, unique: true

      t.string :topics, array: true, default: []
      t.index :topics, using: 'gin'

      t.timestamps
    end
  end
end
