class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      # Post and owner
      t.bigint :post_id, foreign_key: true, null: false
      t.bigint :owner_id, foreign_key: true, null: false

      t.timestamps
    end

    # Indexes
    add_index :likes, :owner_id
    add_index :likes, :post_id
    add_index :likes, %i[owner_id post_id], unique: true
  end
end
