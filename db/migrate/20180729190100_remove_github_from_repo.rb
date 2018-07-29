class RemoveGithubFromRepo < ActiveRecord::Migration[6.0]
  def change
    remove_column :repos, :github_repo_id, :bigint, null: false
    remove_column :repos, :github_repo_full_name, :string, null: false
  end
end
