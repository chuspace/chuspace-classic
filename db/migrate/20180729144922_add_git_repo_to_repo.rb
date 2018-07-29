class AddGitRepoToRepo < ActiveRecord::Migration[6.0]
  def change
    add_column :repos, :git_repo, :string
  end
end
