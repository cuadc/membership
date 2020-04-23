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

ActiveRecord::Schema.define(version: 2020_04_23_221453) do

  create_table "institutions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
  end

  create_table "members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "camdram_id"
    t.string "crsid"
    t.string "last_name"
    t.string "other_names"
    t.string "primary_email"
    t.string "secondary_email"
    t.bigint "institution_id"
    t.integer "graduation_year"
    t.bigint "type_id"
    t.date "expiry"
    t.text "password"
    t.index ["institution_id"], name: "index_members_on_institution_id"
    t.index ["type_id"], name: "index_members_on_type_id"
  end

  create_table "provider_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_provider_accounts_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_provider_accounts_on_user_id"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "login_at", null: false
    t.datetime "expires_at", null: false
    t.string "ip", null: false
    t.string "user_agent", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "provider_accounts", "users"
  add_foreign_key "sessions", "users"
end
