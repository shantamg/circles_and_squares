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

ActiveRecord::Schema.define(:version => 20140330022331) do

  create_table "affiliates", :force => true do |t|
    t.string "name"
  end

  create_table "affiliations", :force => true do |t|
    t.integer "person_id"
    t.integer "affiliate_id"
    t.string  "notes"
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "board_memberships", :force => true do |t|
    t.integer  "board_position_id"
    t.string   "person_id"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "board_positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "breathing_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "children", :force => true do |t|
    t.integer  "registration_id"
    t.string   "name"
    t.integer  "age"
    t.text     "dietary_and_medical"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "co_registrations", :force => true do |t|
    t.integer  "registration_id"
    t.integer  "co_registration_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "drawings", :force => true do |t|
    t.integer  "user_id"
    t.text     "sprites_json", :limit => 2147483647
    t.string   "name"
    t.integer  "salt"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "likes",                              :default => 0
    t.string   "based_on"
    t.integer  "complexity"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "program_id"
    t.date     "date"
    t.time     "start"
    t.time     "end"
    t.string   "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "extra_step_entries", :force => true do |t|
    t.integer  "extra_step_id"
    t.integer  "registration_id"
    t.boolean  "bool_val"
    t.date     "date_val"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "extra_step_entries", ["extra_step_id"], :name => "index_extra_step_entries_on_extra_step_id"
  add_index "extra_step_entries", ["registration_id"], :name => "index_extra_step_entries_on_registration_id"

  create_table "extra_steps", :force => true do |t|
    t.string   "name"
    t.integer  "program_id"
    t.boolean  "requires_date",             :default => false, :null => false
    t.boolean  "required_for_registration", :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "extra_steps", ["program_id"], :name => "index_extra_steps_on_program_id"

  create_table "facilities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "facilities_programs", :force => true do |t|
    t.integer  "program_id"
    t.integer  "facility_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "flags", :force => true do |t|
    t.integer  "person_id"
    t.integer  "user_id"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "food_requirements", :force => true do |t|
    t.integer  "person_id"
    t.integer  "special_diet_id"
    t.text     "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "guest_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "houses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "how_heard_options", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "import_fields", :force => true do |t|
    t.integer  "web_import_id"
    t.string   "name"
    t.string   "field_id"
    t.text     "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "import_fields", ["web_import_id"], :name => "index_import_fields_on_web_import_id"

  create_table "incharges", :force => true do |t|
    t.integer  "area_id"
    t.integer  "person_id"
    t.date     "start"
    t.date     "end"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "meals", :force => true do |t|
    t.string   "name"
    t.date     "day"
    t.time     "start_time"
    t.text     "notes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "meals", ["day"], :name => "index_meals_on_day"

  create_table "meditation_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "person_id"
    t.string   "year"
    t.boolean  "life_member", :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "phone"
    t.string   "phone2"
    t.string   "fax"
    t.string   "website"
    t.string   "primary_activity"
    t.string   "secondary_activity"
    t.string   "educational_facility"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "contact_name"
    t.string   "contact_email"
  end

  create_table "participant_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first"
    t.string   "sanskrit"
    t.string   "last"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "citizenship"
    t.string   "email"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "phone"
    t.string   "phone2"
    t.string   "fax"
    t.string   "emergency_name"
    t.string   "emergency_relationship"
    t.string   "emergency_email"
    t.string   "emergency_phone"
    t.text     "notes"
    t.boolean  "deceased",                    :default => false, :null => false
    t.boolean  "do_not_email",                :default => false, :null => false
    t.string   "do_not_email_explanation"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "medical_condition"
    t.text     "medical_condition_treatment"
    t.text     "other_personal_info"
    t.string   "middle"
  end

  create_table "prerequisites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "program_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.boolean  "no_dates",              :default => false, :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.time     "arrival_time"
    t.time     "departure_time"
    t.text     "notes"
    t.integer  "program_category_id"
    t.integer  "organization_id"
    t.integer  "person_id"
    t.integer  "registration_capacity"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "rental",                :default => false, :null => false
    t.boolean  "ignore_if_unconfirmed", :default => false, :null => false
  end

  create_table "programs_prerequisites", :force => true do |t|
    t.integer  "program_id"
    t.integer  "prerequisite_id"
    t.date     "due"
    t.date     "completed"
    t.string   "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "registration_alerts", :force => true do |t|
    t.integer  "registration_id"
    t.text     "info"
    t.boolean  "completed"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "registration_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "registration_notes", :force => true do |t|
    t.integer  "registration_id"
    t.integer  "user_id"
    t.text     "notes"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "registration_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "registrations", :force => true do |t|
    t.integer  "person_id"
    t.integer  "program_id"
    t.string   "room_notes"
    t.integer  "guest_type_id"
    t.integer  "yoga_level_id"
    t.text     "pre_existing_health_conditions"
    t.integer  "how_heard_option_id"
    t.string   "how_heard_details"
    t.date     "cancellation_date"
    t.string   "cancellation_reason"
    t.text     "registration_details"
    t.integer  "registration_group_id"
    t.integer  "registration_status_id"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.boolean  "housing_not_needed",                    :default => false, :null => false
    t.boolean  "first_time",                            :default => false, :null => false
    t.string   "wait_list_notes"
    t.boolean  "confirmed",                             :default => false, :null => false
    t.boolean  "staff",                                 :default => false, :null => false
    t.date     "wait_list_date"
    t.integer  "breathing_level_id"
    t.integer  "meditation_level_id"
    t.text     "dietary_needs"
    t.string   "payment_plan_admin_fee"
    t.string   "meals_and_lodging_first_session_type"
    t.string   "meals_and_lodging_first_session_cost"
    t.string   "meals_and_lodging_second_session_type"
    t.string   "meals_and_lodging_second_session_cost"
    t.string   "registration_fee"
    t.string   "tuition"
  end

  add_index "registrations", ["breathing_level_id"], :name => "index_registrations_on_breathing_level_id"
  add_index "registrations", ["meditation_level_id"], :name => "index_registrations_on_meditation_level_id"
  add_index "registrations", ["yoga_level_id"], :name => "index_registrations_on_yoga_level_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "house_id"
    t.integer  "twin_beds"
    t.integer  "double_beds"
    t.boolean  "ensuite_bathroom", :default => false, :null => false
    t.boolean  "staff_housing",    :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "special_diets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stays", :force => true do |t|
    t.integer  "person_id"
    t.integer  "registration_id"
    t.integer  "room_id"
    t.boolean  "in_double",       :default => false, :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.time     "check_in_time"
    t.time     "check_out_time"
    t.text     "notes"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "camping_own",     :default => false, :null => false
    t.boolean  "commuting",       :default => false, :null => false
    t.boolean  "camping_centre",  :default => false, :null => false
  end

  add_index "stays", ["end_date"], :name => "index_stays_on_end_date"
  add_index "stays", ["registration_id"], :name => "index_stays_on_registration_id"
  add_index "stays", ["room_id"], :name => "index_stays_on_room_id"
  add_index "stays", ["start_date"], :name => "index_stays_on_start_date"

  create_table "users", :force => true do |t|
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "person_id"
    t.integer  "roles_mask"
    t.boolean  "active",                 :default => true, :null => false
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "web_imports", :force => true do |t|
    t.integer  "gravity_form_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "title"
    t.boolean  "imported",        :default => false
  end

  create_table "yoga_certification_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "yoga_certifications", :force => true do |t|
    t.integer  "person_id"
    t.integer  "yoga_school_id"
    t.integer  "yoga_certification_type_id"
    t.date     "completion_date"
    t.string   "yoga_alliance_number"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "yoga_class_waivers", :force => true do |t|
    t.integer  "person_id"
    t.integer  "registration_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "yoga_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "yoga_schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
