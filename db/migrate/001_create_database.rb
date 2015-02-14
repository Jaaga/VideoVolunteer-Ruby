class 001CreateDatabase < ActiveRecord::Migration
  def change
    create_table "ccdata", primary_key: "ccid", force: :cascade do |t|
      t.string "name",       limit: 30
      t.string "state",      limit: 30
      t.string "district",   limit: 30
      t.string "village",    limit: 30
      t.string "statecodes", limit: 20
    end

    create_table "tracker", primary_key: "uid", force: :cascade do |t|
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

    create_table "trackerOld", primary_key: "uid", force: :cascade do |t|
      t.text "ccname",                 limit: 65535
      t.text "state",                  limit: 65535
      t.text "program",                limit: 65535
      t.text "iutheme",                limit: 65535
      t.text "description",            limit: 65535
      t.text "storydate",              limit: 65535
      t.text "mentor",                 limit: 65535
      t.text "storytype",              limit: 65535
      t.text "shootplan",              limit: 65535
      t.text "relateduid",             limit: 65535
      t.text "impactpossible",         limit: 65535
      t.text "targetofficial",         limit: 65535
      t.text "desiredchange",          limit: 65535
      t.text "impactplan",             limit: 65535
      t.text "impactfollowup",         limit: 65535
      t.text "impactfollowupnotes",    limit: 65535
      t.text "impactprocess",          limit: 65535
      t.text "impactstatus",           limit: 65535
      t.text "impactdate",             limit: 65535
      t.text "screeningdone",          limit: 65535
      t.text "screeningheadcount",     limit: 65535
      t.text "screeningnotes",         limit: 65535
      t.text "officialinvolved",       limit: 65535
      t.text "officialsatscreening",   limit: 65535
      t.text "officialscreeningnotes", limit: 65535
      t.text "collaborations",         limit: 65535
      t.text "peopleinvolved",         limit: 65535
      t.text "peopleimpacted",         limit: 65535
      t.text "villagesimpacted",       limit: 65535
      t.text "videofoldertitle",       limit: 65535
      t.text "footageinstate",         limit: 65535
      t.text "assignededitor",         limit: 65535
      t.text "footagefromstate",       limit: 65535
      t.text "editedvideofromstate",   limit: 65535
      t.text "editstatus",             limit: 65535
      t.text "footagereview",          limit: 65535
      t.text "roughcutreview",         limit: 65535
      t.text "footagerating",          limit: 65535
      t.text "paymentapproved",        limit: 65535
      t.text "roughcutdate",           limit: 65535
      t.text "editdate",               limit: 65535
      t.text "finalvideorating",       limit: 65535
      t.text "bonus",                  limit: 65535
      t.text "youtubedate",            limit: 65535
      t.text "youtubeurl",             limit: 65535
      t.text "iupublishdate",          limit: 65535
      t.text "videotitle",             limit: 65535
      t.text "subtitleneeded",         limit: 65535
      t.text "secondaryiuissue",       limit: 65535
      t.text "subcategory",            limit: 65535
      t.text "project",                limit: 65535
      t.text "blognotes",              limit: 65535
      t.text "flag",                   limit: 65535
      t.text "flagnotes",              limit: 65535
    end

    create_table "user", primary_key: "uid", force: :cascade do |t|
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
end
