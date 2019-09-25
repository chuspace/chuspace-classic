# typed: true
# frozen_string_literal: true

class AddPreviewImageToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :preview_image_data, :string
  end
end
