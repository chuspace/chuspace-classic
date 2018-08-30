class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos, id: :uuid do |t|
      t.string :name, null: false
      t.string :description

      t.string :url, null: false
      t.uuid :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
