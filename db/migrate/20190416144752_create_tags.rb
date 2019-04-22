class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      # Content
      t.string :name,
                        null: false
      t.citext :slug, null: false

      t.timestamps
    end

    # Index
    add_index :tags, :name, unique: true
    add_index :tags, :slug, unique: true
  end
end
