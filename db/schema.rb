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

ActiveRecord::Schema.define(:version => 20111208130216) do

  create_table "compact_disks", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "title",              :null => false
    t.string   "artist",             :null => false
    t.string   "genre",              :null => false
    t.date     "date"
    t.text     "description"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "role",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", :force => true do |t|
    t.integer  "compact_disk_id", :null => false
    t.string   "title",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "provider_id",      :null => false
    t.integer  "receiver_id",      :null => false
    t.integer  "provider_disk_id", :null => false
    t.integer  "receiver_disk_id", :null => false
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id",                               :default => 1,        :null => false
    t.string   "alias"
    t.string   "lastname",                                                    :null => false
    t.string   "firstname",                                                   :null => false
    t.string   "email",                                                       :null => false
    t.string   "state",                                 :default => "active", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     :limit => 128, :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

end
