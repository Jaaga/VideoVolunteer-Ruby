class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
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
end
