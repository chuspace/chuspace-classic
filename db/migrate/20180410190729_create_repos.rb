class CreateRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :repos, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      # Association
      t.uuid :user_id, null: false
      # Github
      t.bigint :github_repo_id, null: false
      t.string :github_repo_full_name, null: false

      t.timestamps
    end

    add_index :repos, :slug, unique: true
    add_index :repos, :github_repo_id, unique: true
  end
end
