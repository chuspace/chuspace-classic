# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid, force: :cascade do |t|
      ## Database authenticatable
      t.string :name, null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :username, null: false, default: ""
      t.string :avatar

      # Profile
      t.text :bio
      t.string :login_token
      t.string :url, default: "", index: true
      t.string :company, default: "", index: true
      t.string :location, default: "", index: true

      # Github
      t.bigint :github_uid
      t.string :github_access_token
      t.bigint :github_repo_id

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :github_uid, unique: true
  end
end
