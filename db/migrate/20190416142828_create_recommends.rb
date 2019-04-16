class CreateRecommends < ActiveRecord::Migration[6.0]
  def change
    create_table :recommends do |t|
      t.string :text, null: false
      t.bigint :post_id, foreign_key: true, null: false
      t.bigint :owner_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :recommends, :owner_id
    add_index :recommends, :post_id
  end
end
