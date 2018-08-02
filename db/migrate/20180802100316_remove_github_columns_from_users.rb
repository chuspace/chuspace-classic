class RemoveGithubColumnsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, :github_uid
    remove_column :users, :github_nickname, :string
    remove_column :users, :github_uid, :bigint
    remove_column :users, :github_access_token, :string
  end
end
