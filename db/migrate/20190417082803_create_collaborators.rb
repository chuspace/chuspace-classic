class CreateCollaborators < ActiveRecord::Migration[6.0]
  def change
    create_table :collaborators do |t|
      # Post and user
      t.bigint :post_id,
                              foreign_key: true
      t.bigint :user_id, foreign_key: true

      t.timestamps
    end

    # Indexes
    add_index :collaborators, :user_id
    add_index :collaborators, :post_id
    add_index :collaborators, %i[user_id post_id], unique: true
  end
end
