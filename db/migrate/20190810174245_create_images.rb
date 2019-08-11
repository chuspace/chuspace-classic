class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :name
      t.index %i[repository_id name], unique: true

      t.jsonb :image_data
      t.string :blob_path
      t.index %i[repository_id blob_path], unique: true

      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
