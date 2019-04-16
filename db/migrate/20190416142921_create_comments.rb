class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :text, null: false
      t.bigint :author_id, foreign_key: true, null: false
      t.bigint :post_id, foreign_key: true, null: false

      t.bigint :reactions_count, default: 0

      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, :post_id
  end
end
