class CreateUserRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :user_relationships do |t|
      t.bigint :follower_id, foreign_key: true, null: false
      t.bigint :followed_id, foreign_key: true, null: false

      t.timestamps
    end

    add_index :user_relationships, :follower_id
    add_index :user_relationships, :followed_id
    add_index :user_relationships, %i[follower_id followed_id], unique: true
  end
end
