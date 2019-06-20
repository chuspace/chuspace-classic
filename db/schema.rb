# typed: false
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_16_142830) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'images', force: :cascade do |t|
    t.jsonb 'image_data'
    t.string 'blob_path'
    t.bigint 'repository_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[blob_path], name: 'index_images_on_blob_path', unique: true
    t.index %w[repository_id], name: 'index_images_on_repository_id'
  end

  create_table 'invites', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'code', null: false
    t.string 'status', default: 'invited', null: false
    t.bigint 'user_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[code], name: 'index_invites_on_code', unique: true
    t.index %w[email], name: 'index_invites_on_email', unique: true
    t.index %w[status], name: 'index_invites_on_status'
    t.index %w[user_id], name: 'index_invites_on_user_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.string 'slug'
    t.text 'excerpt'
    t.text 'body'
    t.bigint 'author_id', null: false
    t.string 'blob_path'
    t.bigint 'repository_id', null: false
    t.string 'ancestry'
    t.integer 'status', default: 0, null: false
    t.string 'topics', default: [], array: true
    t.datetime 'published_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[ancestry], name: 'index_posts_on_ancestry'
    t.index %w[author_id], name: 'index_posts_on_author_id'
    t.index %w[blob_path], name: 'index_posts_on_blob_path', unique: true
    t.index %w[published_at], name: 'index_posts_on_published_at'
    t.index %w[repository_id], name: 'index_posts_on_repository_id'
    t.index %w[status], name: 'index_posts_on_status'
    t.index %w[topics], name: 'index_posts_on_topics', using: :gin
  end

  create_table 'repositories', force: :cascade do |t|
    t.string 'name', default: 'blog.git', null: false
    t.string 'path', null: false
    t.string 'commit_sha', null: false
    t.bigint 'author_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[author_id], name: 'index_repositories_on_author_id'
    t.index %w[commit_sha], name: 'index_repositories_on_commit_sha', unique: true
    t.index %w[name author_id], name: 'index_repositories_on_name_and_author_id', unique: true
    t.index %w[path], name: 'index_repositories_on_path', unique: true
  end

  create_table 'ssh_keys', force: :cascade do |t|
    t.string 'title'
    t.text 'key', null: false
    t.string 'fingerprint', null: false
    t.bigint 'user_id', null: false
    t.datetime 'last_used'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[fingerprint], name: 'index_ssh_keys_on_fingerprint', unique: true
    t.index %w[key], name: 'index_ssh_keys_on_key', unique: true
    t.index %w[last_used], name: 'index_ssh_keys_on_last_used'
    t.index %w[user_id], name: 'index_ssh_keys_on_user_id'
  end

  create_table 'topics', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[name], name: 'index_topics_on_name', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', default: '', null: false
    t.string 'email', default: '', null: false
    t.string 'nickname', default: '', null: false
    t.jsonb 'avatar_data'
    t.string 'auth_token', default: '', null: false
    t.text 'bio'
    t.string 'company'
    t.string 'location'
    t.string 'url'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.inet 'current_sign_in_ip'
    t.inet 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[auth_token], name: 'index_users_on_auth_token', unique: true
    t.index %w[email], name: 'index_users_on_email', unique: true
    t.index %w[nickname], name: 'index_users_on_nickname', unique: true
  end

  add_foreign_key 'images', 'repositories'
  add_foreign_key 'invites', 'users'
  add_foreign_key 'posts', 'repositories'
  add_foreign_key 'ssh_keys', 'users'
end
