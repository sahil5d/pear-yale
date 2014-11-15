# encoding: UTF-8
# this file is auto-generated from the current state of the database. instead
# of editing this file, please use the migrations feature of active record to
# incrementally modify your database, and then regenerate this schema definition.
#
# note that this schema.rb definition is the authoritative source for your
# database schema. if you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. the latter is a flawed and unsustainable approach

ActiveRecord::Schema.define(version: 20140722134633) do

	create_table "lunches", force: true do |t|
		t.string   "place"
		t.datetime "time"
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	create_table "matches", force: true do |t|
		t.integer  "lunch_id"
		t.integer  "user_id"
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	create_table "openings", force: true do |t|
		t.string   "place"
		t.integer  "weekday"
		t.integer  "minuteTime"
		t.datetime "created_at"
		t.datetime "updated_at"
		t.integer  "user_id"
		t.datetime "date_time"
	end

	create_table "users", force: true do |t|
		t.string   "netid"
		t.string   "fname"
		t.string   "lname"
		t.string   "email"
		t.integer  "year"
		t.string   "college"
		t.string   "major"
		t.datetime "created_at"
		t.datetime "updated_at"
		t.boolean  "admin",      default: false
	end

end
