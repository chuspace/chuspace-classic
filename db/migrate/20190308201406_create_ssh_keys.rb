class CreateSshKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :ssh_keys do |t|
      t.string :title
      t.text :key, null: false
      t.string :fingerprint, null: false
      t.bigint :user_id, foreign_key: true, null: false
      t.datetime :last_used

      t.timestamps
    end

    add_index :ssh_keys, :key, unique: true
    add_index :ssh_keys, :user_id
    add_index :ssh_keys, :last_used
  end
end
