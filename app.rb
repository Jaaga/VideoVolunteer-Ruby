require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
require 'haml'
require 'mysql'
require './.config/environment'
require 'date'


# Classes for database tables.
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
  @track = Tracker.all
  @flag = 0

  @track.each do |t|
    @flag += 1 if !t.flag.blank?
  end

  haml :index
end


# For escaping user inputed code.
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

#
# Forms
#

# New Stories

get '/new' do
  @arr = ['uid', 'ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan']

  haml :new
end

post '/new' do
  @track = Tracker.new
  arr = ['uid', 'ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.storydate = params[:storydate] if !params[:storydate].blank?
  @track.updatedate = Date.today

  if @track.uid.length > 2
    @track.save
    redirect '/recent'
  else
    puts "UID needs to be more than 2 characters long."
  end
end


# Add story impact information
get '/impact' do
  haml :impact
end

post '/impactEditor' do
  @track = Tracker.find_by(uid: params[:uid])
  @arr = ['description', 'impactpossible', 'targetofficial', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes']
  @dates = ['impactdate']

  haml :editImpact
end

post '/impact/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = ['description', 'impactpossible', 'targetofficial', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes']
  dates = ['impactdate']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.updatedate = Date.today

  @track.save
  redirect '/recent'
end

# Add footage information
get '/footage' do
  haml :footage
end

post '/footageEditor' do
  @track = Tracker.find_by(uid: params[:uid])
  @arr = ['footageinstate', 'assignededitor', 'footagereview', 'footagerating']
  @dates = ['impactdate']

  haml :editFootage
end

post '/footage/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = ['footageinstate', 'assignededitor', 'footagereview', 'footagerating']
  dates = ['impactdate']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.updatedate = Date.today

  @track.save
  redirect '/recent'
end

# Recent Stories

get '/recent' do
  @track = Tracker.where(:updatedate => Date.today-14...Date.today+1).order("updatedate DESC")
  @title = 'Recent Stories'

  haml :search_results
end


# Search Functions

get '/search' do
  haml :search
end

post '/search_results/uid' do
  @track = Tracker.where(uid: params[:uid]).order("uid ASC")
  @title = 'Search Results'

  haml :search_results
end

post '/search_results/state' do
  @track = Tracker.where(state: params[:state]).order("state ASC")
  @title = 'Search Results'

  haml :search_results
end

post '/search_results/ccname' do
  @track = Tracker.where(ccname: params[:ccname]).order("ccname ASC")
  @title = 'Search Results'

  haml :search_results
end

#
# General app mechanics
#

# Viewing, deleting, and editing individual stories.

get '/show/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  haml :show
end

get '/delete/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  @track.destroy

  redirect '/recent'
end

get '/edit/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  @arr = ['ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes', 'collaborations', 'peopleinvolved', 'peopleimpacted', 'villagesimpacted', 'videofoldertitle', 'assignededitor', 'editstatus', 'footagereview', 'roughcutreview', 'footagerating', 'paymentapproved', 'finalvideorating', 'bonus', 'youtubeurl', 'videotitle', 'subtitleneeded', 'secondaryiuissue', 'subcategory', 'project', 'blognotes']
  @dates = ['storydate', 'impactdate',  'footagefromstate', 'editedvideofromstate','footageinstate','roughcutdate', 'editdate', 'iupublishdate', 'youtubedate']

  haml :edit
end

post '/edit/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = ['ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes', 'collaborations', 'peopleinvolved', 'peopleimpacted', 'villagesimpacted', 'videofoldertitle', 'assignededitor', 'editstatus', 'footagereview', 'roughcutreview', 'footagerating', 'paymentapproved', 'finalvideorating', 'bonus', 'youtubeurl', 'videotitle', 'subtitleneeded', 'secondaryiuissue', 'subcategory', 'project', 'blognotes']
  dates = ['storydate', 'impactdate',  'footagefromstate', 'editedvideofromstate','footageinstate','roughcutdate', 'editdate', 'iupublishdate', 'youtubedate']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.updatedate = Date.today

  @track.save
  redirect '/recent'
end

#
# Views
#

# Accounts Team View
get '/accounts' do
  haml :account
end

# Editor's View
get '/editor' do
  haml :editor
end

post '/editEditor' do
  @track = Tracker.find_by(uid: params[:uid])
  @arr = ['finalvideorating', 'youtubeurl']
  @dates = ['roughcutdate', 'editdate', 'youtubedate']

  haml :editEditor
end

post '/editor/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = ['finalvideorating', 'youtubeurl']
  dates = ['roughcutdate', 'editdate', 'youtubedate']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.updatedate = Date.today

  @track.save
  redirect '/recent'
end

# Production View
get '/production' do
  haml :production
end
#
# Notes
#

# Flagging and unflagging individual stories

get '/flag' do
  @track = Tracker.where(flag: 'priority').order("updatedate ASC")
  @title = 'Flagged Stories'

  haml :search_results
end

get '/flag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  haml :flagnote
end

post '/flag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  @track.flagnotes = "#{Date.today}: #{params[:note]}"
  @track.flag = "priority"
  @track.updatedate = Date.today
  @track.save

  redirect '/recent'
end

get '/unflag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  @track.flag = nil
  @track.flagnotes = nil
  @track.updatedate = Date.today
  @track.save

  redirect '/recent'
end


# Making notes on correspondents

get '/note' do
  haml :note
end

post '/note' do
  @track = Tracker.find_by(uid: params[:uid])

  if @track.note.blank?
    @track.note = "#{Date.today}: #{params[:note]}"
  else
    temp = @track.note
    @track.note = "#{Date.today}: #{params[:note]}<br>#{temp}"
  end

  @track.updatedate = Date.today
  @track.save

  redirect '/recent'
end
