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

ActiveRecord::Schema.define(:version => 20130422161222) do

  create_table "analog_input_logs", :force => true do |t|
    t.integer  "value"
    t.integer  "analog_input_id"
    t.datetime "created_at"
  end

  add_index "analog_input_logs", ["analog_input_id", "created_at"], :name => "index_analog_input_logs_on_analog_input_id_and_created_at"

  create_table "analog_input_types", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "analog_input_types", ["code"], :name => "index_analog_input_types_on_code", :unique => true

  create_table "analog_inputs", :force => true do |t|
    t.string   "name",                                                       :null => false
    t.string   "address",                                                    :null => false
    t.integer  "size",            :limit => 1,                               :null => false
    t.decimal  "reference",                    :precision => 8, :scale => 2, :null => false
    t.integer  "base_station_id",                                            :null => false
    t.integer  "type_id",                                                    :null => false
    t.datetime "deactivated_at"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "analog_inputs", ["base_station_id", "deactivated_at", "type_id"], :name => "base_station_id"

  create_table "base_stations", :force => true do |t|
    t.string   "name",                           :null => false
    t.integer  "xbee_rx_pin",       :limit => 1
    t.integer  "xbee_tx_pin",       :limit => 1
    t.string   "timezone"
    t.string   "mac_address"
    t.integer  "system_id",                      :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.datetime "config_updated_at"
  end

  add_index "base_stations", ["mac_address"], :name => "index_base_stations_on_mac_address", :unique => true
  add_index "base_stations", ["system_id"], :name => "index_base_stations_on_system_id"

  create_table "control_blocks", :force => true do |t|
    t.integer  "minute",            :limit => 1
    t.integer  "hour",              :limit => 1
    t.integer  "day",               :limit => 1
    t.integer  "month",             :limit => 1
    t.integer  "weekday",           :limit => 1
    t.integer  "len",               :limit => 2,                   :null => false
    t.boolean  "state",                          :default => true, :null => false
    t.datetime "deactivated_at"
    t.integer  "base_station_id",                                  :null => false
    t.integer  "digital_output_id",                                :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "year",              :limit => 2
  end

  add_index "control_blocks", ["base_station_id", "deactivated_at"], :name => "index_control_blocks_on_base_station_id_and_deactivated_at"

  create_table "digital_output_types", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "digital_output_types", ["code"], :name => "index_digital_output_types_on_code"

  create_table "digital_outputs", :force => true do |t|
    t.string   "address",                    :null => false
    t.string   "name",                       :null => false
    t.datetime "deactivated_at"
    t.integer  "base_station_id",            :null => false
    t.integer  "type_id",                    :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "transient_control_block_id"
  end

  add_index "digital_outputs", ["base_station_id", "deactivated_at", "type_id"], :name => "base_station_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subscriptions", :force => true do |t|
    t.string   "access_level"
    t.integer  "system_id",    :null => false
    t.integer  "user_id",      :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "subscriptions", ["user_id", "system_id"], :name => "user_id_system_id"

  create_table "systems", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "login",                            :null => false
    t.string   "crypted_password",                 :null => false
    t.string   "password_salt",                    :null => false
    t.string   "persistence_token",                :null => false
    t.integer  "login_count",       :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
