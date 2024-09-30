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

ActiveRecord::Schema[7.2].define(version: 2024_09_29_203904) do
  create_table "station_readings", force: :cascade do |t|
    t.float "celcius_temp", null: false
    t.float "relative_humidity", null: false
    t.datetime "recorded_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
