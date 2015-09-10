# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150826193110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amazon_products", force: :cascade do |t|
    t.string   "url"
    t.string   "product_id"
    t.string   "description"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "clones", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "leads", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_code"
    t.string   "ip"
    t.string   "source"
    t.string   "referer"
    t.datetime "start_time"
    t.string   "campaign"
    t.string   "browser"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "saved_to_zoho"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "geocoded"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "recommendable_id"
    t.string  "recommendable_type"
    t.integer "user_id"
    t.integer "concierge_id"
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "key"
    t.text     "content"
    t.string   "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.integer  "clone_id"
  end

  add_index "snippets", ["ancestry"], name: "index_snippets_on_ancestry", using: :btree
  add_index "snippets", ["clone_id"], name: "index_snippets_on_clone_id", using: :btree

end
