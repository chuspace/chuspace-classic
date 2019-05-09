class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.string :email, null: false
      t.index :email, unique: true
      t.string :code, null: false
      t.index :code, unique: true

      t.integer :status, null: false, default: 0
      t.index :status

      t.timestamps
    end
  end
end
