class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      # User and post
      t.bigint :contributor_id, foreign_key: true, null: false
      t.bigint :post_id, foreign_key: true, null: false

      # Content
      t.string :raw_changes, array: true, default: []
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # Indexes
    add_index :contributions, :status
    add_index :contributions, :contributor_id
    add_index :contributions, :post_id
  end
end
