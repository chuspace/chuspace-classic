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

ActiveRecord::Schema.define(version: 2018_12_15_183817) do

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
    t.string "name", default: "blog", null: false
    t.citext "repo_name", default: "", null: false
    t.string "repo_path", null: false
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_blogs_on_person_id"
    t.index ["repo_name"], name: "index_blogs_on_repo_name", unique: true
    t.index ["repo_path"], name: "index_blogs_on_repo_path", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.citext "nickname", default: "", null: false
    t.string "avatar"
    t.string "auth_token", default: "", null: false
    t.text "bio"
    t.string "company"
    t.string "location"
    t.string "url"
    t.jsonb "github_info", default: "{}"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_people_on_auth_token", unique: true
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["github_info"], name: "index_people_on_github_info", using: :gin
    t.index ["location"], name: "index_people_on_location"
    t.index ["nickname"], name: "index_people_on_nickname", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.citext "slug", null: false
    t.text "body"
    t.bigint "person_id"
    t.bigint "blog_id"
    t.string "tags", default: [], array: true
    t.integer "status", default: 0, null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_posts_on_blog_id"
    t.index ["person_id"], name: "index_posts_on_person_id"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["status"], name: "index_posts_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blogs", "people"
  add_foreign_key "posts", "blogs"
  add_foreign_key "posts", "people"
end
