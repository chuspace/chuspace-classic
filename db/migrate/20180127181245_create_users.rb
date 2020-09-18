# typed: ignore
# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false

      t.text :email_ciphertext
      t.string :email_bidx
      t.index :email_bidx, unique: true

      t.string :nickname, null: false
      t.index :nickname, unique: true

      t.string :provider_name, default: 'github', null: false
      t.string :provider_uid, index: true, unique: true, null: false
      t.text :provider_token_ciphertext, null: false
      t.text :provider_secret_ciphertext, null: false

      t.index %i[provider_name provider_uid], unique: true

      t.integer :posts_count, null: false, default: 0
      t.integer :publications_count, null: false, default: 0

      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      t.timestamps null: false
    end
  end
end
