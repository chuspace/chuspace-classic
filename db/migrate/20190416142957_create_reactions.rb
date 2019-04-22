class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      # Content
      t.text :text,
                      null: false

      # Author and comment
      t.bigint :author_id, foreign_key: true, null: false
      t.bigint :comment_id, foreign_key: true, null: false

      t.timestamps
    end

    # Indexes
    add_index :reactions, :author_id
    add_index :reactions, :comment_id
  end
end
