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

ActiveRecord::Schema[8.1].define(version: 2026_06_18_125008) do
  create_table "oplata", force: :cascade do |t|
    t.boolean "canceled", default: false, null: false
    t.datetime "created_at", null: false
    t.string "date"
    t.float "duration"
    t.string "name"
    t.boolean "pay", default: false, null: false
    t.string "payment_destination"
    t.datetime "updated_at", null: false
  end
end
