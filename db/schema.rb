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

ActiveRecord::Schema.define(version: 20150225093358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "convocations", force: :cascade do |t|
    t.date     "date"
    t.time     "hour"
    t.integer  "subscription_id"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "convocations", ["subscription_id"], name: "index_convocations_on_subscription_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.string   "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subscriptions", ["tournament_id"], name: "index_subscriptions_on_tournament_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "genre"
    t.string   "category"
    t.boolean  "accepted"
    t.integer  "amount"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "address"
    t.string   "city"
    t.string   "name"
    t.string   "club_organisateur"
  end

  add_index "tournaments", ["user_id"], name: "index_tournaments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ranking"
    t.boolean  "judge",                  default: false
    t.string   "genre"
    t.string   "date_of_birth"
    t.string   "licence_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "convocations", "subscriptions"
  add_foreign_key "subscriptions", "tournaments"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tournaments", "users"
end
