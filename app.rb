require 'sinatra'
require 'active_record'
require 'haml'
require './.config/environment'

class Ccdata < ActiveRecord::Base
  self.table_name = "ccdata"
end

class Tracker < ActiveRecord::Base
  self.table_name = "tracker"
end

class TrackerOld < ActiveRecord::Base
  self.table_name = "trackerOld"
end

class User < ActiveRecord::Base
  self.table_name = "user"
end

get '/' do
  haml :index
end

get '/new' do
  @ccdata = Ccdata.all
  @tracker = Tracker.all
  @user = User.all

  haml :new
end

get '/legacy' do
  haml :legacy
end

get '/jh' do
  @tracker = TrackerOld.all

  haml :jh
end

post '/ccdata' do
  @data = Ccdata.new
  @data.name = params[:name]
  @data.state = params[:state]
  @data.district = params[:district]
  @data.village = params[:village]
  @data.statecodes = params[:statecodes]

  if @data.name.length > 0 then @data.save end
  redirect '/new'
end

post '/tracker' do
  @track = Tracker.new
  @track.UID = params[:uid]
  @track.ccname = params[:ccname]
  @track.state = params[:state]
  @track.program = params[:program]
  @track.iutheme = params[:iutheme]
  @track.description = params[:description]
  @track.storydate = params[:storydate]
  @track.ccpair = params[:ccpair]
  @track.mentor = params[:mentor]
  @track.storytype = params[:storytype]
  @track.shootplan = params[:shootplan]
  @track.relateduid = params[:relateduid]
  @track.impactpossible = params[:impactpossible]
  @track.targetofficial = params[:targetofficial]
  @track.desiredchange = params[:desiredchange]
  @track.impactplan = params[:impactplan]
  @track.impactfollowup = params[:impactfollowup]
  @track.impactfollowupnotes = params[:impactfollowupnotes]
  @track.impactprocess = params[:impactprocess]
  @track.impactstatus = params[:impactstatus]
  @track.impactdate = params[:impactdate]
  @track.screeningdone = params[:screeningdone]
  @track.screeningheadcount = params[:screeningheadcount]
  @track.screeningnotes = params[:screeningnotes]
  @track.officialinvolved = params[:officialinvolved]
  @track.officialsatscreening = params[:officialscreening]
  @track.officialscreeningnotes = params[:officialscreeningnotes]
  @track.collaborations = params[:collaboration]
  @track.peopleinvolved = params[:peopleinvolved]
  @track.peopleimpacted = params[:peopleimpacted]
  @track.villagesimpacted = params[:villagesimpacted]
  @track.videofoldertitle = params[:videofoldertitle]
  @track.footageinstate = params[:footageinstate]
  @track.assignededitor = params[:assignededitor]
  @track.footagefromstate = params[:footagefromstate]
  @track.editedvideofromstate = params[:editedvideofromstate]
  @track.editstatus = params[:editstatus]
  @track.footagereview = params[:footagereview]
  @track.roughcutreview = params[:roughcut]
  @track.footagerating = params[:footagerating]
  @track.paymentapproved = params[:paymentapproved]
  @track.roughcutdate = params[:roughcutdate]
  @track.editdate = params[:editdate]
  @track.finalvideorating = params[:finalvideorating]
  @track.bonus = params[:bonus]
  @track.youtubedate = params[:youtubedate]
  @track.youtubeurl = params[:youtubeurl]
  @track.iupublishdate = params[:iupublishdate]
  @track.videotitle = params[:videotitle]
  @track.subtitleneeded = params[:subtitleneeded]
  @track.secondaryiuissue = params[:secondaryiuissue]
  @track.subcategory = params[:subcategory]
  @track.project = params[:project]
  @track.blognotes = params[:blognotes]
  @track.flag = params[:flag]
  @track.flagnotes = params[:flagnotes]

  if @track.ccname.length > 0 then @track.save end
  redirect '/new'
end

post '/user' do
  @user = User.new
  @user.firstname = params[:firstname]
  @user.middlename = params[:middlename]
  @user.lastname = params[:lastname]
  @user.password = params[:password]
  @user.user_type = params[:user_type]
  @user.post = params[:post]
  @user.gender = params[:gender]
  @user.emailid = params[:emailid]
  @user.dob = params[:dob]
  @user.state = params[:state]
  @user.pincode = params[:pincode]
  @user.contactNo = params[:contactNo]
  @user.language = params[:language]
  @user.start_date = params[:start_date]
  @user.login_status = params[:login_status]
  @user.village = params[:village]
  @user.district = params[:district]
  @user.refreeName = params[:refreeName]
  @user.refreeContactNo = params[:refreeContactNo]
  @user.organisation = params[:organisation]

  if @user.lastname.length > 0 then @user.save end
  redirect '/new'
end
