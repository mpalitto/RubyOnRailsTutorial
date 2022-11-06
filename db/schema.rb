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

ActiveRecord::Schema.define(version: 2022_10_08_081002) do

  create_table "tasks", force: :cascade do |t|
    t.string "titolo"
    t.string "interno"
    t.string "contatto"
    t.text "descrizione"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stato"
    t.int "stima_durata"
    t.int "preventivo"
    t.datetime "inizio_lavori", precision: 6, null: false
    t.int "costo_effettivo"
    t.date "completed"
  end

end
