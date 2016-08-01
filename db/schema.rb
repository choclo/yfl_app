# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100419181947) do

  create_table "aircraft_types", :force => true do |t|
    t.integer  "display_order",                :default => 0
    t.string   "slug",          :limit => 16
    t.string   "name",          :limit => 32
    t.string   "description",   :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "remote_data_file_name"
    t.string   "remote_data_content_type"
    t.integer  "remote_data_file_size"
    t.integer  "pilot_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remote_data_updated_at"
    t.string   "local_data_file_name"
    t.string   "local_data_content_type"
    t.integer  "local_data_file_size"
    t.datetime "local_data_updated_at"
    t.boolean  "processing",               :default => true
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "equipment", :force => true do |t|
    t.integer  "equipment_category_id"
    t.integer  "pilot_id"
    t.boolean  "deleted",                              :default => false
    t.string   "name"
    t.string   "notes"
    t.string   "colour"
    t.string   "serial_number"
    t.string   "slug"
    t.integer  "starting_air_time"
    t.string   "starting_air_time_unit", :limit => 16, :default => "minutes", :null => false
    t.date     "purchase_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "air_time_minutes"
  end

  create_table "equipment_categories", :force => true do |t|
    t.integer "display_order", :default => 0
    t.boolean "is_muliselect", :default => false
    t.boolean "multi_use",     :default => false
    t.string  "name"
    t.string  "description"
    t.string  "slug"
  end

  create_table "equipment_category_aircraft_types", :force => true do |t|
    t.integer "equipment_category_id", :null => false
    t.integer "aircraft_type_id",      :null => false
  end

  create_table "flight_types", :force => true do |t|
    t.integer  "display_order",    :default => 0
    t.integer  "aircraft_type_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "launch_types", :force => true do |t|
    t.integer  "display_order",    :default => 0
    t.integer  "aircraft_type_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", :force => true do |t|
    t.integer  "display_order",    :default => 0
    t.integer  "aircraft_type_id"
    t.string   "identifier"
    t.string   "name"
    t.string   "description"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "suggested"
    t.integer  "pilot_id"
  end

  create_table "location_aircraft_types", :force => true do |t|
    t.integer  "location_id"
    t.integer  "aircraft_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "location_wind_directions", :force => true do |t|
    t.integer  "location_id"
    t.integer  "wind_direction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.integer  "pilot_id",                                                                    :null => false
    t.decimal  "lat",                          :precision => 15, :scale => 12
    t.decimal  "lng",                          :precision => 15, :scale => 12
    t.integer  "altitude_masl",                                                :default => 0, :null => false
    t.string   "name",          :limit => 128,                                                :null => false
    t.string   "address1",      :limit => 128
    t.string   "address2",      :limit => 128
    t.string   "address3",      :limit => 128
    t.string   "country",       :limit => 128
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entries", :force => true do |t|
    t.string   "type"
    t.integer  "pilot_id",                                                :null => false
    t.integer  "location_id"
    t.date     "date",                                                    :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "air_time",                         :default => 0,         :null => false
    t.string   "air_time_unit",      :limit => 16, :default => "minutes", :null => false
    t.integer  "number_of_flights",                :default => 1,         :null => false
    t.integer  "minimum_wind_speed"
    t.integer  "average_wind_speed"
    t.integer  "maximum_wind_speed"
    t.integer  "height_gain"
    t.integer  "distance"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "aircraft_type_id"
  end

  create_table "log_entry_equipments", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "log_entry_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entry_flight_types", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "log_entry_id"
    t.integer  "flight_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entry_launch_types", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "log_entry_id"
    t.integer  "launch_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_entry_licenses", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "log_entry_id"
    t.integer  "rating_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "license_id"
  end

  create_table "log_entry_wind_directions", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "log_entry_id"
    t.integer  "wind_direction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pilot_licenses", :force => true do |t|
    t.integer  "pilot_id"
    t.integer  "license_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pilots", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",            :limit => 128
    t.string   "country",         :limit => 64
    t.string   "membership_id",   :limit => 128
    t.boolean  "completed_setup",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "pilot_id"
    t.string   "distance_unit"
    t.string   "speed_unit"
    t.string   "height_unit"
    t.string   "language"
    t.string   "time_zone"
    t.string   "date_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "system_message_status", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_message_status", ["user_id"], :name => "index_system_message_status_on_user_id"

  create_table "system_message_statuses", :force => true do |t|
    t.integer  "user_id"
    t.string   "message_id"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "identity_url"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive"
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "wind_directions", :force => true do |t|
    t.string   "direction",  :limit => 16
    t.string   "cardinal",   :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
