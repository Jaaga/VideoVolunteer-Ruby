class 001CreateDatabase < ActiveRecord::Migration
  def self.up
    create_table "ccdata", primary_key: "ccid", force: :cascade do |t|
      t.string "name",       limit: 30
      t.string "state",      limit: 30
      t.string "district",   limit: 30
      t.string "village",    limit: 30
      t.string "statecodes", limit: 20
    end

    create_table "tracker", primary_key: "UID", force: :cascade do |t|
      t.string  "ccname",                 limit: 20
      t.string  "state",                  limit: 20
      t.string  "program",                limit: 30
      t.string  "iutheme",                limit: 20
      t.string  "description",            limit: 200
      t.date    "storydate"
      t.string  "ccpair",                 limit: 30
      t.string  "mentor",                 limit: 30
      t.string  "storytype",              limit: 20
      t.string  "shootplan",              limit: 500
      t.string  "relateduid",             limit: 20
      t.string  "impactpossible",         limit: 5
      t.string  "targetofficial",         limit: 30
      t.string  "desiredchange",          limit: 300
      t.string  "impactplan",             limit: 300
      t.string  "impactfollowup",         limit: 5
      t.string  "impactfollowupnotes",    limit: 300
      t.string  "impactprocess",          limit: 300
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
      t.string  "videotitle",             limit: 30
      t.string  "subtitleneeded",         limit: 5
      t.string  "secondaryiuissue",       limit: 30
      t.string  "subcategory",            limit: 30
      t.string  "project",                limit: 30
      t.string  "blognotes",              limit: 50
      t.string  "flag",                   limit: 20
      t.string  "flagnotes",              limit: 200
    end

    create_table "user", primary_key: "UID", force: :cascade do |t|
      t.string  "firstname",       limit: 20
      t.string  "middlename",      limit: 20
      t.string  "lastname",        limit: 20
      t.string  "password",        limit: 32
      t.integer "user_type",       limit: 4
      t.string  "post",            limit: 20
      t.string  "gender",          limit: 10
      t.string  "emailid",         limit: 20
      t.date    "dob"
      t.string  "state",           limit: 20
      t.integer "pincode",         limit: 4
      t.integer "contactNo",       limit: 4
      t.string  "language",        limit: 10
      t.date    "start_date"
      t.integer "login_status",    limit: 4
      t.string  "village",         limit: 20
      t.string  "district",        limit: 20
      t.string  "refreeName",      limit: 20
      t.integer "refreeContactNo", limit: 4
      t.integer "organisation",    limit: 4
    end
  end

  def self.down
  end
end
