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

ActiveRecord::Schema.define(version: 20191219120055) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "editnotifications", force: :cascade do |t|
    t.integer "visited_id", null: false
    t.integer "attendance_id"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "after_started_at"
    t.datetime "after_finished_at"
    t.string "note"
    t.string "status", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.boolean "next_day", default: false, null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_editnotifications_on_attendance_id"
    t.index ["user_id"], name: "index_editnotifications_on_user_id"
  end

  create_table "overtimenotifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "attendance_id"
    t.datetime "scheduled_end_time"
    t.string "status", default: "", null: false
    t.string "note", default: "", null: false
    t.boolean "next_day", default: false, null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id"], name: "index_overtimenotifications_on_attendance_id", unique: true
    t.index ["visitor_id"], name: "index_overtimenotifications_on_visitor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "affiliation"
    t.integer "employee_number"
    t.string "uid"
    t.boolean "superior"
    t.datetime "basic_work_time"
    t.datetime "basic_actual_time"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
