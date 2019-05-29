# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, force: :cascade do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.index :email, unique: true
      t.string :nickname, null: false, default: ''
      t.index :nickname, unique: true
      t.string :avatar

      t.string :repo_name, null: false
      t.index :repo_name, unique: false

      t.string :repo_path, null: false
      t.index :repo_path, unique: true

      t.string :auth_token, null: false, default: ''
      t.index :auth_token, unique: true

      t.text :bio
      t.string :company
      t.string :location
      t.string :url

      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      t.timestamps null: false
    end
  end
end
