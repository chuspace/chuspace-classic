# typed: ignore
# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.string :email, null: false
      t.index :email, unique: true

      t.string :nickname, null: false
      t.index :nickname, unique: true

      t.jsonb :avatar_data

      t.string :auth_token, null: false
      t.index :auth_token, unique: true
      t.datetime :auth_token_expires_at

      t.text :bio
      t.string :company
      t.string :location
      t.string :url

      t.integer :posts_count, null: false, default: 0
      t.integer :publications_count, null: false, default: 0
      t.integer :collaborations_count, null: false, default: 0

      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      t.timestamps null: false
    end
  end
end
