class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.bigint :tag_id, foreign_key: true, null: false
      t.bigint :post_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :taggings, :tag_id
    add_index :taggings, :post_id
    add_index :taggings, %i[tag_id post_id], unique: true
  end
end
