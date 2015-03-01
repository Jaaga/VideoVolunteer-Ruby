require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
# For showing input errors.
require 'sinatra/flash'
require 'haml'
require 'date'
require './.config/environment'
require_relative './features'
require_relative './arrays'

include Features
include Arrays
enable :sessions

# Classes for database tables.
class Tracker < ActiveRecord::Base
end

class Cc < ActiveRecord::Base
end

class State < ActiveRecord::Base
end

# Routes
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
  @state = State.all

  haml :new_state
end

post '/new/state' do
  if params[:state].blank?
    flash[:error] = "A state must be selected."
    redirect '/new'
  else
    @state = State.find_by(state: params[:state])
    @cc = Cc.where(state_abb: @state.state_abb)

    haml :new
  end
end

post '/new' do
  if params[:cc_name].blank?
    flash[:error] = "A CC must be selected."
    redirect '/new'
  else
    @track = Tracker.new
    @cc = Cc.find_by(full_name: params[:cc_name])

    # For making UID. Getting list of UID's from state.
    @temp = Tracker.where(state: @cc.state)
    # Sending state UID list and abbreviation of state name
    @track.uid = uid_generate(@temp, @cc.state_abb)

    # Fill in information from chosen cc
    @track.state = @cc.state
    @track.district = @cc.district
    @track.mentor = @cc.mentor

    arr = global_arr_set.push('cc_name', 'flag', 'flag_notes', 'description')
    dates = global_dates_set

    arr.each do |x|
      @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
    end

    dates.each do |x|
      @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
    end

    if @track.uid.length > 2
      @track.save
      redirect '/recent'
    else
      "UID needs to be more than 2 characters long."
    end
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
  @track = Tracker.where(updated_at: Date.today-14...Date.today+1).order("updated_at DESC")
  @title = 'Recent Stories'

  haml :results
end


# Search Function

get '/search' do
  haml :search
end

# Custom queries come through here. Must be before post /search/:standard
post '/search/custom' do
  search = Array.new
  query = 0
  chain = 1

  # Goes through each query row and checks if data is entered for the search query.
  (0..9).each do |x|
    if !params[:"column_#{x}"].blank? && params[:"input_#{x}"].blank?
      search.push("#{params[:"column_#{x}"]} #{params[:"operator_#{x}"]} NULL")
      query += 1
    elsif !params[:"column_#{x}"].blank? && params[:"operator_#{x}"] == "LIKE"
      search.push("#{params[:"column_#{x}"]} #{params[:"operator_#{x}"]} '%#{params[:"input_#{x}"]}%'")
      query += 1
    elsif !params[:"column_#{x}"].blank?
      search.push("#{params[:"column_#{x}"]} #{params[:"operator_#{x}"]} '#{params[:"input_#{x}"]}'")
      query += 1
    end

    # Only add chain if input was filled in and column was chosen.
    if !params[:"chain_#{x}"].blank? && !params[:"column_#{x}"].blank?
      search.push(params[:"chain_#{x}"])
      chain += 1
    end
  end

  # Flash error if there are not enough operators for the queries.
  if query != chain
    flash[:error] = "Need an AND or OR for multiple criteria."
    redirect '/search'
  else
    search = search.join(' ')

    @track = Tracker.where(search)
    @title = 'Search Results'

    haml :results
  end
end


# Standard searches will be here.
post '/search/:standard' do
  search = Array.new

  if params[:standard] == 'pitch'
    search.push("story_pitch_date NOT NULL AND backup_received_date IS NULL")
  end

  if params[:standard] == 'rough'
    search.push("rough_cut_edit_date NOT NULL AND youtube_date IS NULL")
  end

  @track = Tracker.where(search)
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

  haml :edit
end

post '/edit/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = global_arr_set.push('district', 'mentor', 'flag', 'flag_notes', 'description')
  dates = global_dates_set

  arr.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  dates.each do |x|
    @track.send(:"#{x}=", params[:"#{x}"]) if !params[:"#{x}"].blank?
  end

  @track.save
  redirect '/recent'
end


# Flagging and unflagging individual stories

# This get is currently unused, but being kept in case the feature is needed in the future.
# get '/flag' do
#   @track = Tracker.where(flag: 'priority').order("updated_at ASC")
#   @title = 'Flagged Stories'
#
#   haml :results
# end

get '/flag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  haml :flagnote
end

post '/flag/:uid' do
  if params[:note].blank?
    flash[:error] = "Need information for flag."
    redirect "/flag/#{params[:uid]}"
  else
    @track = Tracker.find_by(uid: params[:uid])

    @track.flag_notes = "#{params[:note]}"
    @track.flag = "priority"
    @track.flag_date = Date.today

    @track.save

    redirect '/recent'
  end
end

get '/unflag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  @track.flag = nil
  @track.flag_notes = nil
  @track.flag_date = nil

  @track.save

  redirect '/recent'
end


# Making notes on stories/videos

get '/note' do
  haml :note
end

post '/note' do
  if params[:uid].blank?
    flash[:error] = "UID needed."
    redirect '/note'
  else
    @track = Tracker.find_by(uid: params[:uid])

    if @track.note.blank?
      @track.note = "#{Date.today}: #{params[:note]}"
    else
      temp = @track.note
      @track.note = "#{Date.today}: #{params[:note]}<br>#{temp}"
    end

    @track.save

    redirect '/recent'
  end
end
