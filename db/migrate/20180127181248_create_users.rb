# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid, force: :cascade do |t|
      ## Database authenticatable
      t.string :name, null: false
      t.string :email, null: false
      t.citext :nickname, null: false
      t.string :avatar

      # Passwordless login
      t.string :auth_token, null: false

      # Profile
      t.text :bio
      t.string :company
      t.string :location
      t.string :url

      # Github
      t.jsonb  :github_info, default: '{}'

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :nickname, unique: true
    add_index :users, :auth_token, unique: true
    add_index :users, :location
    add_index  :users, :github_info, using: :gin
  end
end
