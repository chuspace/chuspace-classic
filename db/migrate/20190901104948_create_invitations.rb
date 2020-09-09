# typed: true
# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.references :sender, null: false, index: true, foreign_key: { to_table: :users }
      t.string :identifier, null: false, index: true
      t.index %i[identifier publication_id], unique: true

      t.integer :role, null: false

      t.references :publication, null: false, foreign_key: true

      t.string :code, null: false
      t.index :code, unique: true

      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
