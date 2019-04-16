class CreateTagRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_relationships do |t|
      t.bigint :follower_id, foreign_key: true, null: false
      t.bigint :tag_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :tag_relationships, :follower_id
    add_index :tag_relationships, :tag_id
    add_index :tag_relationships, %i[follower_id tag_id], unique: true
  end
end
