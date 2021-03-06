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

ActiveRecord::Schema.define(version: 20151221145144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "challenges", force: :cascade do |t|
    t.date     "date"
    t.time     "time"
    t.text     "place"
    t.text     "score"
    t.integer  "winner"
    t.integer  "loser"
    t.integer  "referee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "competitions", force: :cascade do |t|
    t.integer  "tournament_id"
    t.string   "category"
    t.string   "min_ranking"
    t.string   "max_ranking"
    t.string   "nature"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "genre"
    t.boolean  "quarante",       default: true
    t.boolean  "NC",             default: true
    t.boolean  "trentecinq",     default: true
    t.boolean  "trentequatre",   default: true
    t.boolean  "trentetrois",    default: true
    t.boolean  "trentedeux",     default: true
    t.boolean  "trenteun",       default: true
    t.boolean  "trente",         default: true
    t.boolean  "quinzecinq",     default: true
    t.boolean  "quinzequatre",   default: true
    t.boolean  "quinzetrois",    default: true
    t.boolean  "quinzedeux",     default: true
    t.boolean  "quinzeun",       default: true
    t.boolean  "quinze",         default: true
    t.boolean  "cinqsix",        default: true
    t.boolean  "quatresix",      default: true
    t.boolean  "troissix",       default: true
    t.boolean  "deuxsix",        default: true
    t.boolean  "unsix",          default: true
    t.boolean  "zero",           default: true
    t.boolean  "moinsdeuxsix",   default: true
    t.boolean  "moinsquatresix", default: true
    t.boolean  "moinsquinze",    default: true
    t.boolean  "premiereserie",  default: true
    t.boolean  "total",          default: true
  end

  add_index "competitions", ["tournament_id"], name: "index_competitions_on_tournament_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.string   "object"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contestants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "challenge_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "contestants", ["challenge_id"], name: "index_contestants_on_challenge_id", using: :btree
  add_index "contestants", ["user_id"], name: "index_contestants_on_user_id", using: :btree

  create_table "convocations", force: :cascade do |t|
    t.date     "date"
    t.time     "hour"
    t.integer  "subscription_id"
    t.string   "status",          default: "pending"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "convocations", ["subscription_id"], name: "index_convocations_on_subscription_id", using: :btree

  create_table "disponibilities", force: :cascade do |t|
    t.string   "week"
    t.string   "saturday"
    t.string   "sunday"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "monday"
    t.string   "tuesday"
    t.string   "wednesday"
    t.string   "thursday"
    t.string   "friday"
    t.text     "comment"
    t.integer  "tournament_id"
    t.integer  "user_id"
  end

  add_index "disponibilities", ["tournament_id"], name: "index_disponibilities_on_tournament_id", using: :btree
  add_index "disponibilities", ["user_id"], name: "index_disponibilities_on_user_id", using: :btree

  create_table "licencieffts", force: :cascade do |t|
    t.date     "date_of_birth"
    t.string   "licence_number"
    t.string   "genre"
    t.string   "ranking"
    t.string   "club"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "full_name"
  end

  create_table "mangopay_transactions", force: :cascade do |t|
    t.string   "status"
    t.integer  "mangopay_transaction_id"
    t.string   "category"
    t.json     "archive"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "tournament_id"
    t.boolean  "cgv",                     default: false
    t.integer  "competition_id"
    t.integer  "subscription_id"
  end

  add_index "mangopay_transactions", ["competition_id"], name: "index_mangopay_transactions_on_competition_id", using: :btree
  add_index "mangopay_transactions", ["subscription_id"], name: "index_mangopay_transactions_on_subscription_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "read_at"
    t.text     "content"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "convocation_id"
    t.boolean  "read",           default: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "read",           default: false
    t.integer  "convocation_id"
    t.integer  "tournament_id"
    t.integer  "competition_id"
  end

  add_index "notifications", ["competition_id"], name: "index_notifications_on_competition_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status",            default: "pending"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "exported",          default: false
    t.boolean  "funds_sent",        default: false
    t.string   "mangopay_payin_id"
    t.integer  "competition_id"
    t.string   "fare_type"
    t.integer  "tournament_id"
  end

  add_index "subscriptions", ["competition_id"], name: "index_subscriptions_on_competition_id", using: :btree
  add_index "subscriptions", ["fare_type"], name: "index_subscriptions_on_fare_type", using: :btree
  add_index "subscriptions", ["tournament_id"], name: "index_subscriptions_on_tournament_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "tournaments", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "accepted",                 default: false
    t.integer  "amount"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "address"
    t.string   "city"
    t.string   "name"
    t.string   "club_organisateur"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "homologation_number"
    t.string   "postcode"
    t.integer  "young_fare"
    t.string   "iban"
    t.string   "bic"
    t.string   "club_email"
    t.string   "mangopay_user_id"
    t.string   "mangopay_wallet_id"
    t.string   "mangopay_bank_account_id"
    t.boolean  "funds_received",           default: false
    t.integer  "club_fare"
    t.string   "region"
    t.boolean  "fft"
  end

  add_index "tournaments", ["user_id"], name: "index_tournaments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",    null: false
    t.string   "encrypted_password",            default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ranking"
    t.boolean  "judge",                         default: false
    t.string   "genre"
    t.string   "licence_number"
    t.integer  "judge_number"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",             default: 0
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.string   "telephone"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "picture"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                         default: false, null: false
    t.string   "licencepicture_file_name"
    t.string   "licencepicture_content_type"
    t.integer  "licencepicture_file_size"
    t.datetime "licencepicture_updated_at"
    t.string   "certifmedpicture_file_name"
    t.string   "certifmedpicture_content_type"
    t.integer  "certifmedpicture_file_size"
    t.datetime "certifmedpicture_updated_at"
    t.integer  "mangopay_card_id"
    t.date     "birthdate"
    t.string   "address"
    t.string   "club"
    t.string   "login_aei"
    t.string   "password_aei"
    t.boolean  "accepted",                      default: false
    t.string   "confirmation_token"
    t.string   "unconfirmed_email"
    t.string   "mangopay_user_id"
    t.string   "mangopay_wallet_id"
    t.boolean  "sms_forfait",                   default: false
    t.integer  "sms_quantity"
    t.string   "extradoc_file_name"
    t.string   "extradoc_content_type"
    t.integer  "extradoc_file_size"
    t.datetime "extradoc_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "competitions", "tournaments"
  add_foreign_key "contestants", "challenges"
  add_foreign_key "contestants", "users"
  add_foreign_key "convocations", "subscriptions"
  add_foreign_key "disponibilities", "tournaments"
  add_foreign_key "disponibilities", "users"
  add_foreign_key "mangopay_transactions", "competitions"
  add_foreign_key "mangopay_transactions", "subscriptions"
  add_foreign_key "notifications", "competitions"
  add_foreign_key "notifications", "users"
  add_foreign_key "subscriptions", "competitions"
  add_foreign_key "subscriptions", "tournaments"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tournaments", "users"
end
