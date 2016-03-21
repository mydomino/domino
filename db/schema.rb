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

ActiveRecord::Schema.define(version: 20160316220506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "availabilities", force: :cascade do |t|
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.boolean  "sunday"
    t.boolean  "morning"
    t.boolean  "afternoon"
    t.boolean  "evening"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clones", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concierges", force: :cascade do |t|
    t.string   "name"
    t.string   "picture"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "concierges", ["email"], name: "index_concierges_on_email", unique: true, using: :btree
  add_index "concierges", ["reset_password_token"], name: "index_concierges_on_reset_password_token", unique: true, using: :btree

  create_table "contests", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "start_date"
    t.string   "headline"
  end

  create_table "dashboards", force: :cascade do |t|
    t.string   "lead_name"
    t.text     "recommendation_explanation"
    t.integer  "concierge_id"
    t.string   "slug"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "lead_email"
  end

  add_index "dashboards", ["concierge_id"], name: "index_dashboards_on_concierge_id", using: :btree

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

  create_table "get_starteds", force: :cascade do |t|
    t.boolean  "solar"
    t.boolean  "energy_analysis"
    t.string   "area_code"
    t.integer  "average_electric_bill"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "profile_id"
    t.integer  "offering_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "interests", ["offering_id"], name: "index_interests_on_offering_id", using: :btree
  add_index "interests", ["profile_id"], name: "index_interests_on_profile_id", using: :btree

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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "saved_to_zoho"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "geocoded"
    t.integer  "get_started_id"
    t.boolean  "subscribe_to_mailchimp"
  end

  create_table "models", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "User"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "models", ["email"], name: "index_models_on_email", unique: true, using: :btree
  add_index "models", ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree

  create_table "offerings", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "url"
    t.string   "product_id"
    t.string   "description"
    t.string   "image_url"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "price"
    t.string   "xml"
    t.string   "name"
    t.boolean  "default",     default: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "housing"
    t.integer  "avg_electrical_bill"
    t.integer  "availability_id"
    t.string   "comments"
    t.string   "partner_code"
    t.boolean  "onboard_complete"
    t.integer  "onboard_step"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "profiles", ["availability_id"], name: "index_profiles_on_availability_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "concierge_id"
    t.integer  "dashboard_id"
    t.boolean  "done"
    t.integer  "recommendable_id"
    t.string   "recommendable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  add_index "recommendations", ["dashboard_id"], name: "index_recommendations_on_dashboard_id", using: :btree
  add_index "recommendations", ["recommendable_id", "recommendable_type"], name: "recommendable_index", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "icon"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "cta_link"
    t.string   "cta_text"
    t.boolean  "default",     default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "interests", "offerings"
  add_foreign_key "interests", "profiles"
  add_foreign_key "profiles", "availabilities"
  add_foreign_key "profiles", "users"
end
