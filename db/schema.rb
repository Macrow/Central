# -*- encoding : utf-8 -*-
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130217164146) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "messages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "inbox",               default: false
    t.integer  "sender_id"
    t.integer  "user_id"
    t.string   "receiver_ids_string"
    t.boolean  "read",                default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "messages", ["receiver_ids_string", "user_id"], name: "index_messages_on_receiver_ids_string_and_user_id"
  add_index "messages", ["sender_id", "user_id"], name: "index_messages_on_sender_id_and_user_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "notifications", force: true do |t|
    t.text     "content"
    t.boolean  "read",       default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "relationships", force: true do |t|
    t.integer "watching_id"
    t.integer "watcher_id"
  end

  add_index "relationships", ["watcher_id"], name: "index_relationships_on_watcher_id"
  add_index "relationships", ["watching_id"], name: "index_relationships_on_watching_id"

  create_table "settings", force: true do |t|
    t.string   "key",         null: false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "settings", ["target_type", "target_id", "key"], name: "index_settings_on_target_type_and_target_id_and_key", unique: true

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar"
    t.string   "sex"
    t.date     "birthday"
    t.string   "location"
    t.string   "sign"
    t.string   "home_url"
    t.string   "description"
    t.string   "register_ip"
    t.string   "last_login_ip"
    t.datetime "last_login_at"
    t.datetime "last_activity_at"
    t.datetime "last_activity_count_at"
    t.integer  "activity_count",         default: 0
    t.integer  "score",                  default: 0
    t.boolean  "admin",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["name", "email"], name: "index_users_on_name_and_email", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid"

end
