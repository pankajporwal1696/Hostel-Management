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

ActiveRecord::Schema[7.0].define(version: 2024_12_15_091036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "resident_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resident_id"], name: "index_bookings_on_resident_id"
    t.index ["room_id"], name: "index_bookings_on_room_id"
  end

  create_table "hostels", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "pincode"
    t.bigint "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_hostels_on_admin_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "rooms", force: :cascade do |t|
    t.string "number"
    t.integer "capacity"
    t.decimal "price", precision: 10, scale: 2
    t.boolean "available", default: true
    t.bigint "hostel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hostel_id"], name: "index_rooms_on_hostel_id"
  end

  create_table "rooms_residents", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "resident_id", null: false
    t.index ["resident_id"], name: "index_rooms_residents_on_resident_id"
    t.index ["room_id", "resident_id"], name: "index_rooms_residents_on_room_id_and_resident_id", unique: true
    t.index ["room_id"], name: "index_rooms_residents_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "type"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "rooms"
  add_foreign_key "bookings", "users", column: "resident_id"
  add_foreign_key "hostels", "users", column: "admin_id"
  add_foreign_key "rooms", "hostels"
  add_foreign_key "rooms_residents", "rooms"
  add_foreign_key "rooms_residents", "users", column: "resident_id"
end
