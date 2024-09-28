# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_28_175939) do
  create_table "email_verification_tokens", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "uuid", null: false
    t.boolean "verified", default: false, null: false
    t.bigint "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_email_verification_tokens_on_member_id"
  end

  create_table "institutions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "camdram_id"
    t.string "crsid"
    t.string "primary_email", null: false
    t.string "secondary_email"
    t.bigint "institution_id", null: false
    t.integer "graduation_year", null: false
    t.bigint "mtype_id", null: false
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "card_issued"
    t.boolean "inhibited", default: false, null: false
    t.text "notes"
    t.boolean "no_mail", default: false, null: false
    t.boolean "needs_card", default: false, null: false
    t.boolean "ucam_mail_accepted"
    t.string "uuid", null: false
    t.index ["camdram_id"], name: "index_members_on_camdram_id", unique: true
    t.index ["crsid"], name: "index_members_on_crsid", unique: true
    t.index ["institution_id"], name: "index_members_on_institution_id"
    t.index ["mtype_id"], name: "index_members_on_mtype_id"
    t.index ["primary_email"], name: "index_members_on_primary_email", unique: true
    t.index ["secondary_email"], name: "index_members_on_secondary_email", unique: true
    t.index ["uuid"], name: "index_members_on_uuid", unique: true
  end

  create_table "provider_accounts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_provider_accounts_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_provider_accounts_on_user_id"
  end

  create_table "purchase_ingest_items", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "cid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "mtype", null: false
    t.boolean "first", null: false
    t.timestamp "purchased", null: false
    t.timestamp "starts", null: false
    t.timestamp "expires"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_purchase_ingest_items_on_member_id"
  end

  create_table "sent_mails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "mailer_class", null: false
    t.string "mailer_action", null: false
    t.string "address", null: false
    t.timestamp "submitted", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "login_at", precision: nil, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.string "ip", null: false
    t.string "user_agent", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "show_contact_details", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "camdram_id", null: false
    t.string "email", null: false
  end

  create_table "types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "ucam_lookup_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.text "data", size: :long, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_ucam_lookup_records_on_member_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sysop", default: false, null: false
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "version_associations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "old_object", size: :long
    t.datetime "created_at"
    t.text "old_object_changes", size: :long
    t.integer "transaction_id"
    t.string "item_subtype"
    t.string "request_uuid"
    t.bigint "session"
    t.string "ip"
    t.string "user_agent"
    t.text "object", size: :long
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "email_verification_tokens", "members"
  add_foreign_key "provider_accounts", "users"
  add_foreign_key "purchase_ingest_items", "members"
  add_foreign_key "sessions", "users"
  add_foreign_key "ucam_lookup_records", "members"
end
