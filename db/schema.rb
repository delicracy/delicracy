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

ActiveRecord::Schema.define(version: 20171018085122) do

  create_table "lanes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "race_id"
    t.decimal "price"
    t.decimal "volume"
    t.decimal "lot"
    t.index ["race_id"], name: "index_lanes_on_race_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "kind"
    t.decimal "volume"
    t.integer "user_id"
    t.integer "lane_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "lot"
    t.decimal "price"
    t.index ["lane_id"], name: "index_offers_on_lane_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "operators", force: :cascade do |t|
    t.integer "host_id"
    t.integer "oracle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "race_id"
    t.index ["host_id", "oracle_id"], name: "index_operators_on_host_id_and_oracle_id"
    t.index ["host_id"], name: "index_operators_on_host_id"
    t.index ["oracle_id"], name: "index_operators_on_oracle_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rule"
    t.string "time_zone"
    t.decimal "initial_lot"
    t.integer "user_id"
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_races_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
