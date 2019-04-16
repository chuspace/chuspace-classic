class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.bigint :contributor_id, foreign_key: true, null: false
      t.bigint :post_id, foreign_key: true, null: false
      t.text :raw_content
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :contributions, :status
    add_index :contributions, :contributor_id
    add_index :contributions, :post_id
  end
end
