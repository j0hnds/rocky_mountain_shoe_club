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

ActiveRecord::Schema.define(:version => 20100913134658) do

  create_table "buyers", :force => true do |t|
    t.integer  "store_id",                 :null => false
    t.string   "first_name", :limit => 40, :null => false
    t.string   "last_name",  :limit => 40, :null => false
    t.string   "phone",      :limit => 12
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinators", :force => true do |t|
    t.string   "first_name", :limit => 40, :null => false
    t.string   "last_name",  :limit => 40, :null => false
    t.string   "email",      :limit => 40, :null => false
    t.string   "phone",      :limit => 12, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibitor_lines", :force => true do |t|
    t.integer  "exhibitor_registration_id",               :null => false
    t.string   "line",                      :limit => 40, :null => false
    t.integer  "priority",                                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibitor_registrations", :force => true do |t|
    t.integer  "exhibitor_id",               :null => false
    t.integer  "show_id",                    :null => false
    t.string   "room",         :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exhibitors", :force => true do |t|
    t.string   "first_name",  :limit => 40, :null => false
    t.string   "last_name",   :limit => 40, :null => false
    t.string   "address_1",   :limit => 40, :null => false
    t.string   "address_2",   :limit => 40
    t.string   "city",        :limit => 40, :null => false
    t.string   "state",       :limit => 2,  :null => false
    t.string   "postal_code", :limit => 11, :null => false
    t.string   "email"
    t.string   "phone",       :limit => 12
    t.string   "fax",         :limit => 12
    t.string   "cell",        :limit => 12
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", :force => true do |t|
    t.string   "description",     :limit => 40, :null => false
    t.integer  "coordinator_id",                :null => false
    t.integer  "venue_id",                      :null => false
    t.date     "start_date",                    :null => false
    t.date     "end_date",                      :null => false
    t.date     "next_start_date",               :null => false
    t.date     "next_end_date",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "name",        :limit => 40, :null => false
    t.string   "address_1",   :limit => 40, :null => false
    t.string   "address_2",   :limit => 40
    t.string   "city",        :limit => 40, :null => false
    t.string   "state",       :limit => 2,  :null => false
    t.string   "postal_code", :limit => 11, :null => false
    t.string   "phone",       :limit => 12
    t.string   "fax",         :limit => 12
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", :force => true do |t|
    t.string   "name",        :limit => 40, :null => false
    t.string   "address_1",   :limit => 40, :null => false
    t.string   "address_2",   :limit => 40
    t.string   "city",        :limit => 40, :null => false
    t.string   "state",       :limit => 2,  :null => false
    t.string   "postal_code", :limit => 11, :null => false
    t.string   "phone",       :limit => 12, :null => false
    t.string   "fax",         :limit => 12
    t.string   "reservation", :limit => 12
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
