class CreateSshKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :ssh_keys do |t|
      # Content
      t.string :title
      t.text :key, null: false
      t.string :fingerprint, null: false

      # User
      t.bigint :user_id, foreign_key: true, null: false

      # Timestamp
      t.datetime :last_used

      t.timestamps
    end

    # Indexes
    add_index :ssh_keys, :key, unique: true
    add_index :ssh_keys, :user_id
    add_index :ssh_keys, :last_used
  end
end
