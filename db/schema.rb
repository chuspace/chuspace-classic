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

ActiveRecord::Schema.define(version: 2019_04_17_082803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "blogs", force: :cascade do |t|
    t.string "name", null: false
    t.citext "slug", null: false
    t.text "introduction"
    t.bigint "author_id"
    t.string "visibility", default: "public"
    t.boolean "default", default: false, null: false
    t.string "repo_name", null: false
    t.string "repo_path", null: false
    t.string "version"
    t.bigint "posts_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_blogs_on_author_id"
    t.index ["posts_count"], name: "index_blogs_on_posts_count"
    t.index ["repo_name"], name: "index_blogs_on_repo_name"
    t.index ["repo_path"], name: "index_blogs_on_repo_path"
    t.index ["slug"], name: "index_blogs_on_slug", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id", "post_id"], name: "index_bookmarks_on_owner_id_and_post_id", unique: true
    t.index ["owner_id"], name: "index_bookmarks_on_owner_id"
    t.index ["post_id"], name: "index_bookmarks_on_post_id"
  end

  create_table "collaborators", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_collaborators_on_post_id"
    t.index ["user_id", "post_id"], name: "index_collaborators_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_collaborators_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "text", null: false
    t.bigint "author_id", null: false
    t.bigint "post_id", null: false
    t.bigint "reactions_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["reactions_count"], name: "index_comments_on_reactions_count"
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "contributor_id", null: false
    t.bigint "post_id", null: false
    t.string "raw_changes", default: [], array: true
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contributor_id"], name: "index_contributions_on_contributor_id"
    t.index ["post_id"], name: "index_contributions_on_post_id"
    t.index ["status"], name: "index_contributions_on_status"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id", "post_id"], name: "index_likes_on_owner_id_and_post_id", unique: true
    t.index ["owner_id"], name: "index_likes_on_owner_id"
    t.index ["post_id"], name: "index_likes_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.citext "slug", null: false
    t.text "excerpt"
    t.text "body"
    t.bigint "author_id", null: false
    t.datetime "published_at"
    t.string "ancestry"
    t.string "visibility", default: "public"
    t.boolean "premium", default: false, null: false
    t.string "blob_id", null: false
    t.bigint "comments_count", default: 0
    t.bigint "recommends_count", default: 0
    t.bigint "bookmarks_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_posts_on_ancestry"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["blob_id"], name: "index_posts_on_blob_id"
    t.index ["bookmarks_count"], name: "index_posts_on_bookmarks_count"
    t.index ["comments_count"], name: "index_posts_on_comments_count"
    t.index ["premium"], name: "index_posts_on_premium"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["recommends_count"], name: "index_posts_on_recommends_count"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["visibility"], name: "index_posts_on_visibility"
  end

  create_table "reactions", force: :cascade do |t|
    t.text "text", null: false
    t.bigint "author_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_reactions_on_author_id"
    t.index ["comment_id"], name: "index_reactions_on_comment_id"
  end

  create_table "ssh_keys", force: :cascade do |t|
    t.string "title"
    t.text "key", null: false
    t.string "fingerprint", null: false
    t.bigint "user_id", null: false
    t.datetime "last_used"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_ssh_keys_on_key", unique: true
    t.index ["last_used"], name: "index_ssh_keys_on_last_used"
    t.index ["user_id"], name: "index_ssh_keys_on_user_id"
  end

  create_table "tag_relationships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follower_id", "tag_id"], name: "index_tag_relationships_on_follower_id_and_tag_id", unique: true
    t.index ["follower_id"], name: "index_tag_relationships_on_follower_id"
    t.index ["tag_id"], name: "index_tag_relationships_on_tag_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_taggings_on_post_id"
    t.index ["tag_id", "post_id"], name: "index_taggings_on_tag_id_and_post_id", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.citext "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "user_relationships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_user_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_user_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_user_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.citext "nickname", default: "", null: false
    t.string "avatar"
    t.string "auth_token", default: "", null: false
    t.text "bio"
    t.string "company"
    t.string "location"
    t.string "url"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["location"], name: "index_users_on_location"
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
