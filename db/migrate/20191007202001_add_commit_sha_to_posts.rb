class AddCommitShaToPosts < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_column :posts, :commit_sha, :text
    add_index :posts, :commit_sha, algorithm: :concurrently
  end
end
