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

ActiveRecord::Schema[7.0].define(version: 2023_08_12_140432) do
  create_table "access_tokens", force: :cascade do |t|
    t.string "token_digest"
    t.integer "user_id", null: false
    t.integer "api_key_id"
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key_id"], name: "index_access_tokens_on_api_key_id"
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "key", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_api_keys_on_key"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "given_name"
    t.string "family_name"
    t.datetime "last_logged_in_at"
    t.string "confirmation_token"
    t.text "confirmation_redirect_url"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "reset_password_token"
    t.text "reset_password_redirect_url"
    t.datetime "reset_password_sent_at"
    t.string "role", default: "user", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "access_tokens", "api_keys"
  add_foreign_key "access_tokens", "users"
end
