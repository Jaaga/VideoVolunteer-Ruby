require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
require 'sinatra/flash'           # For showing input errors.
require 'bcrypt'
require 'haml'
require 'date'
require './.config/environment'

require_relative './lib/features'
require_relative './lib/arrays'
require_relative './lib/forms'
require_relative './lib/users'

include Features
include Arrays
include Forms

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 32400, # In seconds
                           :secret => 'l3m0nad3 is a p0pular dr1nk github'


# Classes for database tables.
class Tracker < ActiveRecord::Base
end

class Cc < ActiveRecord::Base
end

class State < ActiveRecord::Base
end


# For escaping user inputed code.
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
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

get '/login' do
  haml :'/users/login'
end

post '/login' do
  if !session[:user].nil?
    flash[:error] = "Already logged in."
    redirect '/'
  end

  @user = User.find_by(email: params[:email])

  if @user.authenticate?(params[:password]) && !@user.verified.blank?
    session[:user] = @user.id
    redirect '/'
  elsif @user.verified.blank?
    flash[:error] = "Account needs to be verified by administrator."
    redirect back
  elsif !@user.authenticate?(params[:password])
    flash[:error] = "Incorrect email/password combination."
    redirect back
  else
    flash[:error] = "Unkown error."
    redirect back
  end
end

get '/logout' do
  session[:user] = nil
  redirect '/login'
end


# New Stories

get '/new' do
  login_required!

  @state = State.all

  haml :'trackers/new_state'
end

# Getting the state name to give a dropdown of CC's for the state.
post '/new/state' do
  login_required!

  if params[:state].blank?
    flash[:error] = "A state must be selected."
    redirect '/new'
  else
    @state = State.find_by(state: params[:state])
    @cc = Cc.where(state_abb: @state.state_abb)

    haml :'trackers/new'
  end
end

# Saving the data entered for a new story.
post '/new/:state' do
  login_required!

  if params[:cc_name].blank?
    flash[:error] = "A CC must be selected."
    state = params[:state]
    # 307 redirects to a post
    redirect "/new/state?state=#{state}", 307
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

    arr = global_arr_set.push('cc_name')

    arr.each do |x|
      @track.send(:"#{ x }=", params[:"#{ x }"]) if !params[:"#{ x }"].blank?
    end

    if @track.uid.length > 3
      @track.updated_by = current_user[:email]
      @track.save
      flash[:notice] = "Story successfully saved as #{ @track.uid }."
      redirect '/recent'
    else
      flash[:error] = "Did not save story tracker because UID failed to generate."
      redirect back
    end
  end
end


# View all stories

get '/view' do
  @track = Tracker.all
  @title = 'All Stories'

  haml :'trackers/results'
end


# Recent Stories

get '/recent' do
  @track = Tracker.where(updated_at: Date.today-14...Date.today+1).order("updated_at DESC")
  @title = 'Recent Stories'

  haml :'trackers/results'
end


# Search Function

get '/search' do
  haml :'trackers/search'
end

# Custom queries come through here. Must be before post /search/:standard
post '/search/custom' do
  search = Array.new
  query = 0
  chain = 1

  # Goes through each query row and checks if data is entered for the search query.
  (0..9).each do |x|
    if !params[:"column_#{ x }"].blank? && params[:"input_#{ x }"].blank?
      search.push("#{ params[:"column_#{ x }"] } #{ params[:"operator_#{ x }"] } NULL")
      query += 1
    elsif !params[:"column_#{ x }"].blank? && params[:"operator_#{ x }"] == "LIKE"
      search.push("#{ params[:"column_#{ x }"] } #{ params[:"operator_#{ x }"] } '%#{ params[:"input_#{ x }"] }%'")
      query += 1
    elsif !params[:"column_#{ x }"].blank?
      search.push("#{ params[:"column_#{ x }"] } #{ params[:"operator_#{ x }"] } '#{ params[:"input_#{ x }"] }'")
      query += 1
    end

    # Only add chain if input was filled in and column was chosen.
    if !params[:"chain_#{ x }"].blank? && !params[:"column_#{ x }"].blank?
      search.push(params[:"chain_#{ x }"])
      chain += 1
    end
  end

  # Flash error if there are not enough operators for the queries.
  if query != chain
    flash[:error] = "Need enough AND's or OR's for multiple criteria."
    redirect '/search'
  else
    search = search.join(' ')

    @track = Tracker.where(search)
    @title = 'Search Results'

    haml :'trackers/results'
  end
end


# Standard searches will be here.
post '/search/:standard' do
  search = Array.new

  if params[:standard] == 'pitch'
    search.push("story_pitch_date IS NOT NULL AND backup_received_date IS NULL")
  end

  if params[:standard] == 'rough'
    search.push("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
  end

  @track = Tracker.where(search)
  @title = 'Search Results'

  haml :'trackers/results'
end


#
# General app mechanics
#

# Viewing, deleting, and editing individual stories.

get '/show/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  if @track == nil
    flash[:error] = "Could not find story to show."
    redirect '/recent'
  else
    haml :'trackers/show'
  end
end

get '/delete/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])
  if @track == nil
    flash[:error] = "Could not find story to delete."
    redirect '/recent'
  else
    @track.destroy

    flash[:notice] = "#{ @track.uid } successfully deleted."
    redirect '/recent'
  end
end

# Shows the original data in input forms.
get '/edit/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])

  haml :'trackers/edit'
end

# Saves the data found in get /edit/:uid. It's important that the old data shows,
# otherwise editing will erase the old data if nothing new is put into the fields.
post '/edit/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])
  arr = global_arr_set.push('district', 'mentor')

  arr.each do |x|
    @track.send(:"#{ x }=", params[:"#{ x }"]) if !params[:"#{ x }"].blank?
  end

  @track.updated_by = current_user[:email]
  @track.save
  flash[:notice] = "Tracker #{ @track.uid } successfully edited."
  redirect "/show/#{@track.uid}"
end


# Flagging and unflagging individual stories


get '/flag/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])

  haml :'trackers/flagnote'
end

post '/flag/:uid' do
  login_required!

  if params[:note].blank?
    flash[:error] = "Need information for flag."
    redirect "/flag/#{ params[:uid] }"
  else
    @track = Tracker.find_by(uid: params[:uid])

    @track.flag_notes = "#{ params[:note] }"
    @track.flag = "priority"
    @track.flag_date = Date.today

    @track.save
    flash[:notice] = "Flag successfully added to #{ @track.uid }."
    redirect '/recent'
  end
end

get '/unflag/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])

  @track.flag = nil
  @track.flag_notes = nil
  @track.flag_date = nil

  @track.save
  flash[:notice] = "#{ @track.uid } successfully unflagged."
  redirect '/recent'
end


# Making notes on stories/videos

get '/note' do
  login_required!

  haml :'trackers/note'
end

# Adds a note based on the uid of the story. All notes have dates on them. New
# notes are added at the top with a line break.
post '/note' do
  login_required!

  if params[:uid].blank?
    flash[:error] = "UID needed."
    redirect '/note'
  elsif params[:note].blank?
    flash[:error] = "A note is needed."
    redirect '/note'
  else
    @track = Tracker.find_by(uid: params[:uid].upcase)

    if @track == nil
      flash[:error] = "Invalid UID."
      redirect '/note'
    elsif @track.note.blank?
      @track.note = "#{ Date.today }: #{ params[:note] }"
    else
      temp = @track.note
      @track.note = "#{ Date.today }: #{ params[:note] }<br>#{ temp }"
    end

    @track.save
    flash[:notice] = "Note successfully added to #{ @track.uid }."
    redirect '/recent'
  end
end


# --------------------------------------

#
## User
#

get '/signup' do
  haml :'users/new'
end

post '/signup' do
  @user_test = User.find_by(email: params[:email])

  if !@user_test.nil?
    flash[:error] = "Email already taken."
    redirect back
  end

  @user = User.new
  arr = user_array_set[:new_user] - ['password', 'password_verify']

  @user.full_name = "#{ params[:first_name].capitalize } #{ params[:last_name].capitalize }"

  if params[:password] == params[:password_verify] && params[:password].length > 5
    @user.password_set(params[:password])
  elsif params[:password].length < 6
    flash[:error] = "Password needs to be at least 6 characters long."
    redirect back
  end

  arr.each do |x|
    @user.send(:"#{ x }=", params[:"#{ x }"])
  end

  if !(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i === @user.email)
    flash[:error] = 'Invalid email.'
    redirect back
  end

  @user.save
  flash[:notice] = "Account will have to be verified by administrator."
  redirect '/'
end

get '/user/edit/:id' do
  right_user(params[:id])

  @user = User.find_by(id: params[:id])

  haml :'users/edit'
end

post '/user/edit/:id' do
  right_user(params[:id])

  @user = User.find_by(id: params[:id])
  arr = user_array_set[:user] - ['email', 'encrypted_password']

  if params[:new_password] == params[:new_password_verify] && params[:new_password].length > 5
    @user.password_set(params[:new_password])
  elsif params[:new_password].length < 6
    flash[:error] = "Password needs to be at least 6 characters long."
    redirect back
  end

  arr.each do |x|
    @user.send(:"#{ x }=", params[:"#{ x }"])
  end

  @user.save

  redirect '/user/view'
end

get '/user/view' do
  admin_required!

  @user = User.all

  haml :'users/view'
end

get '/user/show/:id' do
  right_user(params[:id])

  @user = User.find_by(id: params[:id])

  haml :'users/show'
end

get '/user/delete/:id' do
  admin_required!

  @user = User.find_by(id: params[:id])
  @user.destroy

  redirect '/user/view'
end



# --------------------------------------

#
## CC
#

get '/cc/new' do
  admin_required!
  @state = State.all
  haml :'ccs/new'
end

post '/cc/new' do
  admin_required!

  @cc = Cc.new
  arr = cc_array_set - ['state_abb']
  @cc.full_name = "#{ params[:first_name] } #{ params[:last_name] }"

  @state = State.find_by(state: params[:state])
  @cc.state_abb = @state.state_abb

  arr.each do |x|
    @cc.send(:"#{ x }=", params[:"#{ x }"])
  end

  @cc.save
  redirect '/cc/view'
end

get '/cc/edit/:id' do
  admin_required!

  @cc = Cc.find_by(id: params[:id])
  @state = State.all

  haml :'ccs/edit'
end

post '/cc/edit/:id' do
  admin_required!

  @cc = Cc.find_by(id: params[:id])
  arr = cc_array_set - ['state_abb']

  @state = State.find_by(state: params[:state])
  @cc.state_abb = @state.state_abb

  arr.each do |x|
    @cc.send(:"#{ x }=", params[:"#{ x }"])
  end

  @cc.save

  redirect '/cc/view'
end

get '/cc/view' do
  admin_required!

  @cc = Cc.all

  haml :'ccs/view'
end

get '/cc/show/:id' do
  admin_required!

  @cc = Cc.find_by(id: params[:id])

  haml :'ccs/show'
end

get '/cc/delete/:id' do
  admin_required!

  @cc = Cc.find_by(id: params[:id])
  @cc.destroy

  redirect '/cc/view'
end


get '/cc/note' do
  admin_required!

  haml :'ccs/note'
end

# Adds a note based on the id of the CC. All notes have dates on them. New
# notes are added at the top with a line break.
post '/cc/note' do
  login_required!

  if params[:id].blank?
    flash[:error] = "ID needed."
    redirect '/cc/note'
  elsif params[:note].blank?
    flash[:error] = "A note is needed."
    redirect '/cc/note'
  else
    @cc = Cc.find_by(id: params[:id])

    if @cc == nil
      flash[:error] = "Invalid ID."
      redirect '/cc/note'
    elsif @cc.notes.blank?
      @cc.notes = "#{ Date.today }: #{ params[:note] } by user #{ session[:user] }"
    else
      temp = @cc.notes
      @cc.notes = "#{ Date.today }: #{ params[:note] } by user #{ session[:user] }<br>#{ temp }"
    end

    @cc.save
    flash[:notice] = "Note successfully added to #{ @cc.full_name }."
    redirect '/cc/view'
  end
end


# --------------------------------------

#
## State
#

get '/state/new' do
  admin_required!

  haml :'states/new'
end

post '/state/new' do
  admin_required!

  @state = State.new
  arr = state_array_set

  arr.each do |x|
    @state.send(:"#{ x }=", params[:"#{ x }"])
  end

  @state.save
  redirect '/state/view'
end

get '/state/edit/:id' do
  admin_required!

  @state = State.find_by(id: params[:id])

  haml :'states/edit'
end

post '/state/edit/:id' do
  admin_required!

  @state = State.find_by(id: params[:id])
  arr = state_array_set

  arr.each do |x|
    @state.send(:"#{ x }=", params[:"#{ x }"])
  end

  @state.save

  redirect '/state/view'
end

get '/state/view' do
  admin_required!

  @state = State.all

  haml :'states/view'
end

get '/state/show/:id' do
  admin_required!

  @state = State.find_by(id: params[:id])

  haml :'states/show'
end

get '/state/delete/:id' do
  admin_required!

  @state = State.find_by(id: params[:id])
  @state.destroy

  redirect '/state/view'
end
