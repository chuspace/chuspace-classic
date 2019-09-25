# typed: true
# frozen_string_literal: true

class RemoveLogdizeFromPosts < ActiveRecord::Migration[6.0]
  def change
    safety_assured { execute 'DROP TRIGGER IF EXISTS logidze_on_posts on posts;' }
    safety_assured { remove_column :posts, :log_data }
  end
end
