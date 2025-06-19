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

ActiveRecord::Schema[7.2].define(version: 2025_06_18_224724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deputies", force: :cascade do |t|
    t.string "name", null: false
    t.string "registration_id", null: false
    t.string "state", limit: 2, null: false
    t.string "party", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_deputies_on_registration_id", unique: true
    t.index ["state", "name"], name: "index_deputies_on_state_and_name"
    t.index ["state"], name: "index_deputies_on_state"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "deputy_id", null: false
    t.date "issue_date", null: false
    t.string "supplier", null: false
    t.decimal "net_value", precision: 10, scale: 2, null: false
    t.string "document_url", null: false
    t.string "expense_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deputy_id", "net_value"], name: "index_expenses_on_deputy_id_and_net_value"
    t.index ["deputy_id"], name: "index_expenses_on_deputy_id"
    t.index ["issue_date"], name: "index_expenses_on_issue_date"
    t.index ["net_value"], name: "index_expenses_on_net_value"
  end

  add_foreign_key "expenses", "deputies"
end
