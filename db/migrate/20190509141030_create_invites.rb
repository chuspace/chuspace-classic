# frozen_string_literal: true

class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :email, null: false
      t.index :email, unique: true

      t.string :code, null: false
      t.index :code, unique: true

      t.string :status, null: false, default: Invite::DEFAULT_STATUS
      t.index :status

      t.bigint :user_id, foreign_key: true
      t.index :user_id

      t.timestamps
    end
  end
end
