# typed: ignore
# frozen_string_literal: true

class AddLogidzeToPosts < ActiveRecord::Migration[5.0]
  require 'logidze/migration'
  include Logidze::Migration

  def up
    add_column :posts, :log_data, :jsonb


    execute <<-SQL
      CREATE TRIGGER logidze_on_posts
      BEFORE UPDATE OR INSERT ON posts FOR EACH ROW
      WHEN (coalesce(#{current_setting('logidze.disabled')}, '') <> 'on')
      EXECUTE PROCEDURE logidze_logger(5, 'updated_at', '{id, title, summary, body, author_id, blob_path, blob_id, repository_id, ancestry, status, topics, published_at, created_at, updated_at}');
    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS logidze_on_posts on posts;'


    remove_column :posts, :log_data
  end
end
