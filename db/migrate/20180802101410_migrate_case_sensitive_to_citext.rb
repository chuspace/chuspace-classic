class MigrateCaseSensitiveToCitext < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :nickname, :citext
    change_column :repos, :slug, :citext
    change_column :posts, :slug, :citext
  end

  def down
    change_column :users, :nickname, :string
    change_column :repos, :slug, :string
    change_column :posts, :slug, :string
  end
end
