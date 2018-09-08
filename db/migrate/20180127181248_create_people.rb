# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, id: :uuid, force: :cascade do |t|
      ## Database authenticatable
      t.string :name, null: false
      t.string :email, null: false
      t.citext :nickname, null: false
      t.string :avatar

      # Git info
      t.integer :git_repo_id
      t.integer :git_repo_owner_id

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

    add_index :people, :email, unique: true
    add_index :people, :nickname, unique: true
    add_index :people, :auth_token, unique: true
    add_index :people, :location

    add_index :people, :git_repo_id, unique: true
    add_index :people, :git_repo_owner_id, unique: true

    add_index :people, :github_info, using: :gin
  end
end
