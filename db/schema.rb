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

ActiveRecord::Schema.define(:version => 20130228161825) do

  create_table "aims", :force => true do |t|
    t.integer   "swimmer_id"
    t.integer   "qualification_id"
    t.date      "date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer   "role_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string    "full_name"
    t.string    "symbol"
    t.text      "contact"
    t.string    "email"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "competitions", :force => true do |t|
    t.string    "name"
    t.string    "location"
    t.date      "date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "disciplines", :force => true do |t|
    t.string    "gender"
    t.integer   "distance"
    t.string    "course"
    t.string    "stroke"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "mode"
  end

  create_table "entries", :force => true do |t|
    t.integer   "event_id"
    t.integer   "time"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "registration_id"
    t.integer   "heat_id"
    t.integer   "lane"
    t.integer   "relay_id"
  end

  create_table "events", :force => true do |t|
    t.integer   "competition_id"
    t.integer   "discipline_id"
    t.integer   "pos"
    t.integer   "age_min"
    t.integer   "age_max"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "heats", :force => true do |t|
    t.integer   "pos"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "event_id"
  end

  create_table "invitations", :force => true do |t|
    t.integer   "club_id"
    t.integer   "competition_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "performances", :force => true do |t|
    t.integer   "user_id"
    t.integer   "time"
    t.integer   "discipline_id"
    t.string    "name"
    t.string    "competition"
    t.date      "date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "qualification_times", :force => true do |t|
    t.integer   "qualification_id"
    t.integer   "discipline_id"
    t.integer   "age_min"
    t.integer   "age_max"
    t.integer   "time"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "qualifications", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "source"
    t.text      "description"
  end

  create_table "registrations", :force => true do |t|
    t.integer   "swimmer_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "age"
    t.integer   "invitation_id"
    t.integer   "club_id"
  end

  create_table "relays", :force => true do |t|
    t.string    "name"
    t.integer   "age_min"
    t.integer   "age_max"
    t.integer   "invitation_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "gender"
  end

  create_table "results", :force => true do |t|
    t.integer   "entry_id"
    t.integer   "time"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "comment"
    t.integer   "place"
  end

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "seats", :force => true do |t|
    t.integer   "relay_id"
    t.integer   "registration_id"
    t.integer   "pos"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "standards", :force => true do |t|
    t.integer   "competition_id"
    t.integer   "qualification_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "supports", :force => true do |t|
    t.integer   "user_id"
    t.integer   "swimmer_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "surveys", :force => true do |t|
    t.integer  "coach_ability"
    t.integer  "athletes_knowledge"
    t.integer  "technical_competency"
    t.integer  "physical_conditioning"
    t.integer  "strength"
    t.integer  "power"
    t.integer  "agility"
    t.integer  "balance"
    t.integer  "team_work"
    t.integer  "sustainable_power"
    t.integer  "confidence"
    t.integer  "time_management"
    t.integer  "communication"
    t.integer  "motivation"
    t.integer  "health_managment"
    t.integer  "nutrition"
    t.integer  "recovery"
    t.integer  "flexibility"
    t.integer  "local_muscle_endurance"
    t.integer  "cardiovascular_endurance"
    t.integer  "strength_endurance"
    t.integer  "coordination"
    t.integer  "psychological_skills"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "swimmers", :force => true do |t|
    t.string    "first"
    t.string    "last"
    t.integer   "club_id"
    t.date      "birthday"
    t.string    "gender"
    t.string    "registration"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "user_id"
  end

  create_table "users", :force => true do |t|
    t.string    "email",                                 :default => "", :null => false
    t.string    "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                         :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
