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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150226064312) do

  create_table "ccs", force: :cascade do |t|
    t.string "full_name"
    t.string "first_name"
    t.string "last_name"
    t.string "state_abb"
    t.string "state"
    t.string "district"
    t.string "phone"
    t.string "mentor"
    t.string "notes"
  end

  create_table "states", force: :cascade do |t|
    t.string "state",     null: false
    t.string "state_abb", null: false
    t.string "district"
  end

  create_table "trackers", force: :cascade do |t|
    t.string   "uid",                           null: false
    t.string   "state"
    t.string   "cc_name"
    t.string   "district"
    t.string   "mentor"
    t.string   "iu_theme"
    t.string   "subcategory"
    t.string   "description"
    t.string   "story_type"
    t.string   "shoot_plan"
    t.string   "story_rating"
    t.date     "story_date"
    t.string   "editor"
    t.string   "edit_status"
    t.string   "payment_status"
    t.string   "folder_title"
    t.string   "review_notes"
    t.string   "edited_video_rating"
    t.string   "youtube_url"
    t.string   "video_title"
    t.string   "subtitle_info"
    t.string   "subtheme"
    t.string   "project"
    t.string   "reviewer_name"
    t.string   "editor_changes_needed"
    t.string   "cc_feedback"
    t.string   "publishing_suggestions"
    t.string   "final_video_rating"
    t.string   "stalin_notes"
    t.string   "video_type"
    t.date     "received_cc_date"
    t.date     "edit_in_goa_date"
    t.date     "state_rough_cut_date"
    t.date     "goa_rough_cut_date"
    t.date     "raw_footage_review_date"
    t.date     "backup_received_date"
    t.date     "state_edit_date"
    t.date     "edit_received_date"
    t.date     "rough_cut_edit_date"
    t.date     "review_date"
    t.date     "finalized_date"
    t.date     "youtube_date"
    t.date     "iu_publish_date"
    t.string   "impact_possible"
    t.string   "target_official"
    t.string   "target_official_email"
    t.string   "target_official_phone"
    t.string   "desired_change"
    t.string   "impact_plan"
    t.string   "impact_followup"
    t.string   "impact_followup_notes"
    t.string   "impact_uid"
    t.string   "impact_process"
    t.string   "impact_status"
    t.string   "milestone"
    t.string   "impact_time"
    t.string   "collaborations"
    t.string   "people_involved"
    t.string   "people_impacted"
    t.string   "villages_impacted"
    t.string   "impact_production_status"
    t.string   "impact_review"
    t.string   "payment_approved"
    t.string   "impact_reviewer"
    t.date     "impact_date"
    t.date     "impact_approval_date"
    t.string   "screening_done"
    t.string   "screening_headcount"
    t.string   "screening_notes"
    t.string   "official_involved"
    t.string   "officials_at_screening_number"
    t.string   "officials_at_screening"
    t.string   "official_screening_notes"
    t.string   "flag"
    t.string   "flag_notes"
    t.text     "note"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trackers", ["uid"], name: "index_trackers_on_uid", unique: true

end
