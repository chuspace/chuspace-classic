class CreateSshKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :ssh_keys, id: :uuid do |t|
      t.uuid :user_id, foreign_key: true
      t.string :name
      t.text :key, null: false

      t.timestamps
    end

     add_index :ssh_keys, :key, unique: true
  end
end
