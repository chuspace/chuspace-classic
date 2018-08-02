class AddGithubInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :github_info, :jsonb, default: '{}'
    add_index  :users, :github_info, using: :gin
  end
end
