# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid, force: :cascade do |t|
      ## Database authenticatable
      t.string :name, null: false
      t.string :email, null: false
      t.string :nickname, null: false
      t.string :avatar

      # Passwordless login
      t.string :auth_token, null: false

      # Profile
      t.text :bio
      t.string :website
      t.string :company
      t.string :location

      # Github
      t.bigint :github_uid
      t.string :github_access_token

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
    add_index :users, :github_uid, unique: true
    add_index :users, :auth_token, unique: true
  end
end
