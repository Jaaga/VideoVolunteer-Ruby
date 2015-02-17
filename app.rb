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


# New Stories

get '/new' do
  @arr = ['uid', 'ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes', 'collaborations', 'peopleinvolved', 'peopleimpacted', 'villagesimpacted', 'videofoldertitle', 'assignededitor', 'editstatus', 'footagereview', 'roughcutreview', 'footagerating', 'paymentapproved', 'finalvideorating', 'bonus', 'youtubeurl', 'videotitle', 'subtitleneeded', 'secondaryiuissue', 'subcategory', 'project', 'blognotes']
  @dates = ['storydate', 'impactdate',  'footagefromstate', 'editedvideofromstate','footageinstate','roughcutdate', 'editdate', 'iupublishdate', 'youtubedate']

  haml :new
end

post '/new' do
  @track = Tracker.new
  arr = ['uid', 'ccname', 'state', 'program', 'iutheme', 'description', 'mentor', 'storytype', 'shootplan', 'relateduid', 'impactpossible', 'targetofficial', 'desiredchange', 'impactplan', 'impactfollowup', 'impactfollowupnotes', 'impactprocess', 'impactstatus', 'screeningdone', 'screeningheadcount', 'screeningnotes', 'officialinvolved', 'officialsatscreening', 'officialscreeningnotes', 'collaborations', 'peopleinvolved', 'peopleimpacted', 'villagesimpacted', 'videofoldertitle', 'assignededitor', 'editstatus', 'footagereview', 'roughcutreview', 'footagerating', 'paymentapproved', 'finalvideorating', 'bonus', 'youtubeurl', 'videotitle', 'subtitleneeded', 'secondaryiuissue', 'subcategory', 'project', 'blognotes']
  dates = ['storydate', 'impactdate',  'footagefromstate', 'editedvideofromstate','footageinstate','roughcutdate', 'editdate', 'iupublishdate', 'youtubedate']

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.updatedate = Date.today

  if @track.uid.length > 2
    @track.save
    redirect '/recent'
  else
    "UID needs to be more than 2 characters long."
  end
end


# View all stories

get '/view' do
  @track = Tracker.all
  @title = 'All Stories'

  haml :results
end


# Recent Stories

get '/recent' do
  @track = Tracker.where(:updatedate => Date.today-14...Date.today+1).order("updatedate DESC")
  @title = 'Recent Stories'

  haml :results
end


# Search Function

get '/search' do
  haml :search
end

post '/search' do
  data = Array.new
  index = Array.new
  search = Array.new

  if !params[:uid].blank?
    data.push('"' + params[:uid] + '"')
    index.push("uid")
  end

  if params[:flag] == "on"
    data.push("\"priority\"")
    index.push("flag")
  end

  if !params[:state].blank?
    data.push('"' + params[:state] + '"')
    index.push("state")
  end

  if !params[:ccname].blank?
    data.push('"' + params[:ccname] + '"')
    index.push("ccname")
  end

  index.each_with_index do |v, i|
    search.push("#{v} = #{data[i]}")
  end

  search = search.join(" AND ")

  @track = Tracker.where("#{search}")
  @title = 'Search Results'

  haml :results
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


# Flagging and unflagging individual stories

get '/flag' do
  @track = Tracker.where(flag: 'priority').order("updatedate ASC")
  @title = 'Flagged Stories'

  haml :results
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
