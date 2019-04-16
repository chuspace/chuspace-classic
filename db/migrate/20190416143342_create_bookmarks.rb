class CreateBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :bookmarks do |t|
      t.bigint :owner_id, foreign_key: true, null: false
      t.bigint :post_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :bookmarks, :owner_id
    add_index :bookmarks, :post_id
    add_index :bookmarks, %i[owner_id post_id], unique: true
  end
end
