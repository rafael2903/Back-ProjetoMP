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

ActiveRecord::Schema.define(version: 2021_04_28_235959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "form_answers", force: :cascade do |t|
    t.string "answers"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "form_id", null: false
    t.bigint "user_id", null: false
    t.index ["form_id"], name: "index_form_answers_on_form_id"
    t.index ["user_id"], name: "index_form_answers_on_user_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_forms_on_user_id"
  end

  create_table "user_has_forms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "form_id", null: false
    t.index ["form_id"], name: "index_user_has_forms_on_form_id"
    t.index ["user_id"], name: "index_user_has_forms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.boolean "is_admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "form_answers", "forms"
  add_foreign_key "form_answers", "users"
  add_foreign_key "forms", "users"
  add_foreign_key "user_has_forms", "forms"
  add_foreign_key "user_has_forms", "users"
end
