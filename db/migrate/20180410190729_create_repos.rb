class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos, id: :uuid do |t|
      t.string :name, null: false
      t.bigint :github_id, null: false
      t.uuid :user_id, null: false
      t.string :description

      t.timestamps
    end
  end
end
