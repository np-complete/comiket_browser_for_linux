# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "blocks", :force => true do |t|
    t.integer  "comiket_no"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blocks", ["comiket_no"], :name => "index_blocks_on_comiket_no"

  create_table "checklists", :force => true do |t|
    t.integer  "comiket_no"
    t.integer  "circle_id"
    t.integer  "color_id"
    t.text     "memo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "checklists", ["color_id"], :name => "index_checklists_on_color_id"
  add_index "checklists", ["comiket_no", "circle_id"], :name => "index_checklists_on_comiket_no_and_circle_id"

  create_table "circles", :force => true do |t|
    t.integer  "circle_id"
    t.integer  "comiket_no"
    t.integer  "day"
    t.integer  "block_id"
    t.integer  "space_no"
    t.string   "name"
    t.string   "name_kana"
    t.string   "author"
    t.string   "book"
    t.text     "description"
    t.integer  "cut_index"
    t.integer  "genre_code"
    t.integer  "page"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "circles", ["comiket_no", "circle_id"], :name => "index_circles_on_comiket_no_and_circle_id"
  add_index "circles", ["comiket_no", "day", "block_id", "space_no"], :name => "circle_space"
  add_index "circles", ["name"], :name => "index_circles_on_name"

  create_table "colors", :force => true do |t|
    t.string   "color"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "unknowns", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.text     "memo"
    t.integer  "color_id"
    t.integer  "comiket_no"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unknowns", ["author"], :name => "index_unknowns_on_author"
  add_index "unknowns", ["comiket_no"], :name => "index_unknowns_on_comiket_no"
  add_index "unknowns", ["name"], :name => "index_unknowns_on_name"

end
