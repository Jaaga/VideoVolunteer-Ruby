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

ActiveRecord::Schema.define(version: 20150224125830) do

  create_table "trackers", force: :cascade do |t|
    t.string  "uid",                    limit: 8
    t.string  "ccname",                 limit: 20
    t.string  "state",                  limit: 20
    t.string  "program",                limit: 30
    t.string  "iutheme",                limit: 20
    t.string  "description",            limit: 2000
    t.date    "storydate"
    t.string  "mentor",                 limit: 30
    t.string  "storytype",              limit: 20
    t.string  "shootplan",              limit: 500
    t.string  "relateduid",             limit: 20
    t.string  "impactpossible",         limit: 5
    t.string  "targetofficial",         limit: 30
    t.string  "desiredchange",          limit: 300
    t.string  "impactplan",             limit: 2000
    t.string  "impactfollowup",         limit: 5
    t.string  "impactfollowupnotes",    limit: 300
    t.string  "impactprocess",          limit: 800
    t.string  "impactstatus",           limit: 20
    t.date    "impactdate"
    t.string  "screeningdone",          limit: 5
    t.integer "screeningheadcount",     limit: 4
    t.string  "screeningnotes",         limit: 300
    t.integer "officialinvolved",       limit: 4
    t.integer "officialsatscreening",   limit: 4
    t.text    "officialscreeningnotes", limit: 65535
    t.string  "collaborations",         limit: 300
    t.integer "peopleinvolved",         limit: 4
    t.integer "peopleimpacted",         limit: 4
    t.integer "villagesimpacted",       limit: 4
    t.string  "videofoldertitle",       limit: 100
    t.date    "footageinstate"
    t.string  "assignededitor",         limit: 30
    t.date    "footagefromstate"
    t.date    "editedvideofromstate"
    t.string  "editstatus",             limit: 20
    t.string  "footagereview",          limit: 300
    t.string  "roughcutreview",         limit: 300
    t.integer "footagerating",          limit: 4
    t.string  "paymentapproved",        limit: 5
    t.date    "roughcutdate"
    t.date    "editdate"
    t.integer "finalvideorating",       limit: 4
    t.string  "bonus",                  limit: 5
    t.date    "youtubedate"
    t.string  "youtubeurl",             limit: 120
    t.date    "iupublishdate"
    t.string  "videotitle",             limit: 200
    t.string  "subtitleneeded",         limit: 5
    t.string  "secondaryiuissue",       limit: 30
    t.string  "subcategory",            limit: 30
    t.string  "project",                limit: 30
    t.string  "blognotes",              limit: 50
    t.string  "flag",                   limit: 20
    t.string  "flagnotes",              limit: 200
    t.date    "updatedate"
    t.text    "note",                   limit: 65535
  end

end
