# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 2019_05_09_141030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index ['record_type', 'record_id', 'name', 'blob_id'], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['filename'], name: 'index_active_storage_blobs_on_filename'
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'blogs', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.text 'introduction'
    t.bigint 'author_id'
    t.integer 'status', default: 0, null: false
    t.string 'repo_name', null: false
    t.string 'repo_path', null: false
    t.boolean 'default', default: false, null: false
    t.bigint 'posts_count', default: 0, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['author_id', 'repo_name'], name: 'index_blogs_on_author_id_and_repo_name', unique: true
    t.index ['author_id', 'slug'], name: 'index_blogs_on_author_id_and_slug', unique: true
    t.index ['default'], name: 'index_blogs_on_default'
    t.index ['repo_path'], name: 'index_blogs_on_repo_path', unique: true
    t.index ['status'], name: 'index_blogs_on_status'
  end

  create_table 'contributions', force: :cascade do |t|
    t.bigint 'contributor_id', null: false
    t.bigint 'post_id', null: false
    t.string 'raw_changes', default: [], array: true
    t.integer 'status', default: 0, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['contributor_id'], name: 'index_contributions_on_contributor_id'
    t.index ['post_id'], name: 'index_contributions_on_post_id'
    t.index ['status'], name: 'index_contributions_on_status'
  end

  create_table 'friendly_id_slugs', force: :cascade do |t|
    t.string 'slug', null: false
    t.integer 'sluggable_id', null: false
    t.string 'sluggable_type', limit: 50
    t.string 'scope'
    t.datetime 'created_at'
    t.index ['slug', 'sluggable_type', 'scope'], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope', unique: true
    t.index ['slug', 'sluggable_type'], name: 'index_friendly_id_slugs_on_slug_and_sluggable_type'
    t.index ['sluggable_type', 'sluggable_id'], name: 'index_friendly_id_slugs_on_sluggable_type_and_sluggable_id'
  end

  create_table 'invites', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'code', null: false
    t.string 'status', default: 'invited', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['code'], name: 'index_invites_on_code', unique: true
    t.index ['email'], name: 'index_invites_on_email', unique: true
    t.index ['status'], name: 'index_invites_on_status'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title', null: false
    t.string 'slug', null: false
    t.text 'excerpt'
    t.text 'body'
    t.bigint 'author_id', null: false
    t.bigint 'blog_id', null: false
    t.datetime 'published_at'
    t.integer 'status', default: 0, null: false
    t.string 'ancestry'
    t.string 'blob_id', null: false
    t.jsonb 'frontmatter'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['ancestry'], name: 'index_posts_on_ancestry'
    t.index ['blob_id'], name: 'index_posts_on_blob_id', unique: true
    t.index ['published_at'], name: 'index_posts_on_published_at'
    t.index ['slug', 'blog_id', 'author_id'], name: 'index_posts_on_slug_and_blog_id_and_author_id', unique: true
    t.index ['status'], name: 'index_posts_on_status'
  end

  create_table 'ssh_keys', force: :cascade do |t|
    t.string 'title'
    t.text 'key', null: false
    t.string 'fingerprint', null: false
    t.bigint 'user_id', null: false
    t.datetime 'last_used'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['key'], name: 'index_ssh_keys_on_key', unique: true
    t.index ['last_used'], name: 'index_ssh_keys_on_last_used'
    t.index ['user_id'], name: 'index_ssh_keys_on_user_id'
  end

  create_table 'taggings', force: :cascade do |t|
    t.bigint 'tag_id', null: false
    t.bigint 'post_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['post_id'], name: 'index_taggings_on_post_id'
    t.index ['tag_id', 'post_id'], name: 'index_taggings_on_tag_id_and_post_id', unique: true
    t.index ['tag_id'], name: 'index_taggings_on_tag_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_tags_on_name', unique: true
    t.index ['slug'], name: 'index_tags_on_slug', unique: true
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', default: '', null: false
    t.string 'email', default: '', null: false
    t.string 'nickname', default: '', null: false
    t.string 'avatar'
    t.string 'blog_storage_path', null: false
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
    t.index ['auth_token'], name: 'index_users_on_auth_token', unique: true
    t.index ['blog_storage_path'], name: 'index_users_on_blog_storage_path', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['nickname'], name: 'index_users_on_nickname', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
end
