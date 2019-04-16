class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.bigint :follower_id, foreign_key: true
      t.bigint :followed_id, foreign_key: true

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, %i[follower_id followed_id], unique: true
  end
end
