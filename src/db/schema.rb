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

ActiveRecord::Schema.define(:version => 20111030195232) do

  create_table "compact_disks", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "artist"
    t.string   "genre"
    t.date     "date"
    t.string   "image_uri"
    t.text     "description"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", :force => true do |t|
    t.integer  "compact_disk_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "provider_id"
    t.integer  "receiver_id"
    t.integer  "provider_disk_id"
    t.integer  "receiver_disk_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id"
    t.string   "alias"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "email"
    t.string   "password"
    t.string   "image_uri"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
