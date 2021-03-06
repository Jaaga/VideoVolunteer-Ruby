require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
require 'sinatra/flash'           # For showing input errors.
require 'bcrypt'
require 'haml'
require 'date'
require 'time'
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
                           :expire_after => 32400, # 9 hours
                           :secret => 'l3m0nad3 is a p0pular dr1nk github'


# Classes for database tables.
class Tracker < ActiveRecord::Base
end

class Cc < ActiveRecord::Base
  before_save { first_name.capitalize! }
  before_save { last_name.capitalize! }
  before_save { district.capitalize! }
  before_save { mentor.capitalize! }
end

class State < ActiveRecord::Base
  before_save { state.capitalize! }
  before_save { state_abb.capitalize! }
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

  # Count the number of fagged stories.
  @track.each do |t|
    @flag += 1 if !t.flag.blank?
  end

  # Number of stories pitched but not yet filmed.
  @pitch = Tracker.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL")
  # Number of rough cuts that haven't yet been finalzied.
  @rough = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
  # Number of videos with an impact achieved
  @impact = Tracker.where("impact_achieved = ?", 'yes')
  # Videos whose rough cuts have arrived from a state office and need to be cleaned, reviewed and uploaded
  @goa_bank = Tracker.where("edit_received_in_goa_date IS NOT NULL AND youtube_date IS NULL")
  # Total approved videos whose edits haven't reached goa
  @state_bank = Tracker.where("edit_received_in_goa_date IS NULL AND rough_cut_edit_date IS NOT NULL")
  # Videos on hold
  @hold = Tracker.where("proceed_with_edit_and_payment = ?", 'On hold')
  # Videos uploaded to youtube
  @youtube = Tracker.where("youtube_date IS NOT NULL")

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

  # Make sure that two videos with the smae UID aren't created.
  params[:original_uid].upcase!
  temp = Tracker.find_by(uid: "#{ params[:original_uid] }_impact")
  check_uid = Tracker.find_by(uid: params[:original_uid])
  if !temp.nil?
    flash[:error] = "Impact video already made for this UID."
    state = params[:state]
    # 307 redirects to a post
    redirect "/new/state?state=#{state}", 307
  # Make sure that the original_uid exists if it is given.
  elsif check_uid.nil? && !params[:original_uid].blank?
    flash[:error] = "Original UID does not exist for impact information."
    state = params[:state]
    # 307 redirects to a post
    redirect "/new/state?state=#{state}", 307
  elsif params[:cc_name].blank?
    flash[:error] = "A CC must be selected."
    state = params[:state]
    # 307 redirects to a post
    redirect "/new/state?state=#{state}", 307
  elsif params[:is_impact] == 'yes' && (params[:original_uid].blank? && params[:no_original_uid].blank?)
    flash[:error] = "An original UID or a reason for not having one must be given for an impact video."
    state = params[:state]
    redirect "/new/state?state=#{state}", 307
  else
    @track = Tracker.new
    @cc = Cc.find_by(full_name: params[:cc_name])

    # For making UID. Getting list of UID's from state.
    @temp = Tracker.where(state: @cc.state)
    # If it's an impact video, either the original UID or the reason for not
    # having one will be recorded. Also sets the impact video status of all
    # videos created.
    if params[:is_impact] == 'yes'
      @track.original_uid = params[:original_uid] unless params[:original_uid].blank?
      @track.no_original_uid = params[:no_original_uid] unless params[:no_original_uid].blank?
      @track.impact_video_status = 'Not done yet' if params[:original_uid].blank?
    else
      @track.impact_video_status = 'Not done yet'
    end
    # Sending state UID list and abbreviation of state name
    @track.uid = uid_generate(@temp, @cc.state_abb, params[:is_impact])

    # Fill in information from chosen cc
    @track.state = @cc.state
    @track.district = @cc.district
    @track.mentor = @cc.mentor

    arr = global_arr_set.push('cc_name')

    arr.each do |x|
      @track.send(:"#{ x }=", params[:"#{ x }"]) if !params[:"#{ x }"].blank?
    end

    # Videos start off in state.
    @track.footage_location = 'State'

    if @track.uid.length > 3
      @track.updated_by = "#{ Date.today }: #{ current_user[:email] } created this tracker."
      @track.save
      if !params[:original_uid].blank? then impact_uid_set(params[:original_uid]) end
      flash[:notice] = "Story successfully saved as #{ @track.uid }."
      redirect "/show/#{ @track.uid }"
    else
      flash[:error] = "Did not save story tracker because UID failed to generate."
      redirect back
    end
  end
end


# View all stories

get '/view' do
  @track = Tracker.all.order("id DESC")
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

  if params[:standard] == 'impact'
    search.push("impact_achieved = ?", 'yes')
  end

  @track = Tracker.where(search)
  @title = 'Search Results'

  haml :'trackers/results'
end


#
# Views
#


get '/views/:employee/:type' do

  employee = employee_set

  if employee[:editor].include? params[:employee]
    @title = 'Editor View'
    if params[:type] == 'edit'
      @search = Tracker.where("editor_currently_in_charge = ? AND cleared_for_edit = ?", "#{params[:employee]}", 'yes').order("updated_at DESC")
      @title_header = "Cleared For Edit"
    else
      @search = Tracker.where("editor_currently_in_charge = ? AND finalized_date IS NOT NULL", "#{params[:employee]}").order("updated_at DESC")
      @title_header = "Has Been Finalized"
    end
  elsif employee[:sc].include? params[:employee]
    @title = 'State Coordinator View'
    if params[:type] == 'pitched'
      @search = Tracker.where("state = ? AND story_pitch_date IS NOT NULL AND backup_received_date IS NULL", "#{params[:employee]}").order("updated_at DESC")
      @title_header = "Has been Pitched But Has No Footage"
    elsif params[:type] == 'pending'
      @search = Tracker.where("state = ? AND raw_footage_review_date IS NULL AND footage_location = ?", "#{params[:employee]}", 'State').order("updated_at DESC")
      @title_header = "Raw Footage Has Not Been Reviewed and Footage is in State"
    elsif params[:type] == 'hold'
      @search = Tracker.where("state = ? AND proceed_with_edit_and_payment = ?", "#{params[:employee]}", 'On hold').order("updated_at DESC")
      @title_header = "Edit and Payment is on Hold"
    end
  end

  haml :'trackers/views'
end


# Editor view
get '/views/editor' do
  @edit = Tracker.where("cleared_for_edit = ?", 'yes').order("updated_at DESC")
  @finalize = Tracker.where("finalized_date IS NOT NULL").order("updated_at DESC")

  @title_edit = "Cleared For Edit"
  @title_finalize = "Has Been Finalized"

  @title = 'Editor View'
  haml :'trackers/editor_view'
end

# State Coordinator view
get '/views/state' do
  @pitched = Tracker.where("story_pitch_date IS NOT NULL AND backup_received_date IS NULL").order("updated_at DESC")
  @pending = Tracker.where("raw_footage_review_date IS NULL AND footage_location = ?", 'State').order("updated_at DESC")
  @hold = Tracker.where("proceed_with_edit_and_payment = ?", 'On hold').order("updated_at DESC")

  @title_pitched = "Has been Pitched But Has No Footage"
  @title_pending = "Raw Footage Has Not Been Reviewed and Footage is in State"
  @title_hold = "Edit and Payment is on Hold"

  @title = 'State Coordinator View'
  haml :'trackers/state_view'
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
  admin_required!

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
  updated = Array.new

  arr.each do |x|
    unless params[:"#{ x }"].blank?
      if @track.send(:"#{ x }").blank? then updated.push(name_modifier(x)) end
      @track.send(:"#{ x }=", params[:"#{ x }"])
    end
  end

  # updated = updated.join(', ') # Leaving it out for now for readability.
  @track.updated_by = "#{ Date.today }: #{ current_user[:email] } changed #{ updated }.<br>#{ @track.updated_by }" unless updated.blank?
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
    @track.updated_by = "#{ Date.today }: #{ current_user[:email] } flagged this tracker.<br>#{ @track.updated_by }"

    @track.save
    flash[:notice] = "Flag successfully added to #{ @track.uid }."
    redirect "/show/#{ params[:uid] }"
  end
end

get '/unflag/:uid' do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])

  @track.flag = nil
  @track.flag_notes = nil
  @track.flag_date = nil
  @track.updated_by = "#{ Date.today }: #{ current_user[:email] } unflagged this tracker.<br>#{ @track.updated_by }"

  @track.save
  flash[:notice] = "#{ @track.uid } successfully unflagged."
  redirect "/show/#{ params[:uid] }"
end


# Making notes on stories/videos

get "/note/:uid" do
  login_required!

  @track = Tracker.find_by(uid: params[:uid])

  haml :'trackers/note'
end

# Adds a note based on the uid of the story. All notes have dates on them. New
# notes are added at the top with a line break.
post '/note/:uid' do
  login_required!

  if params[:note].blank?
    flash[:error] = "A note is needed."
    redirect '/note'
  else
    @track = Tracker.find_by(uid: params[:uid])

    if @track == nil
      flash[:error] = "UID error"
      redirect '/note'
    elsif @track.note.blank?
      @track.note = "#{ Date.today }: #{ params[:note] } (by #{ current_user[:name] })"
    else
      temp = @track.note
      @track.note = "#{ Date.today }: #{ params[:note] } (by #{ current_user[:name] })<br>#{ temp }"
    end

    @track.updated_by = "#{ Date.today }: #{ current_user[:email] } added a note."
    @track.save
    flash[:notice] = "Note successfully added to #{ @track.uid }."
    redirect "/show/#{ params[:uid] }"
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

  # First name and last name capitalized by user class.
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

  unless params[:new_password].blank?
    if params[:new_password] == params[:new_password_verify] && params[:new_password].length > 5
      @user.password_set(params[:new_password])
    elsif params[:new_password].length < 6
      flash[:error] = "Password needs to be at least 6 characters long."
      redirect back
    end
  end

  arr.each do |x|
    @user.send(:"#{ x }=", params[:"#{ x }"])
  end

  @user.save

  redirect "/user/show/#{ params[:id] }"
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
  if session[:user] != params[:id].to_i
    @user = User.find_by(id: params[:id])
    @user.destroy

    redirect '/user/view'
  else
    flash[:error] = "Can't delete self."
    redirect back
  end
end

get '/user/reset' do
  haml :'users/reset'
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
  @cc.full_name = "#{ params[:first_name].capitalize } #{ params[:last_name].capitalize }"

  @state = State.find_by(state: params[:state])
  @cc.state_abb = @state.state_abb

  arr.each do |x|
    @cc.send(:"#{ x }=", params[:"#{ x }"])
  end

  @cc.save
  flash[:notice] = "CC successfully created."
  redirect '/cc/view'
end

get '/cc/edit/:id' do
  login_required!

  @cc = Cc.find_by(id: params[:id])
  @state = State.all

  haml :'ccs/edit'
end

post '/cc/edit/:id' do
  login_required!

  @cc = Cc.find_by(id: params[:id])
  arr = cc_array_set - ['state_abb']

  @state = State.find_by(state: params[:state])
  @cc.state_abb = @state.state_abb
  @cc.full_name = "#{ params[:first_name].capitalize } #{ params[:last_name].capitalize }"

  arr.each do |x|
    @cc.send(:"#{ x }=", params[:"#{ x }"])
  end

  @cc.save
  flash[:notice] = "CC successfully edited."
  redirect '/cc/view'
end

get '/cc/view' do
  login_required!

  @cc = Cc.all

  haml :'ccs/view'
end

get '/cc/show/:id' do
  login_required!

  @cc = Cc.find_by(id: params[:id])

  haml :'ccs/show'
end

get '/cc/delete/:id' do
  admin_required!

  @cc = Cc.find_by(id: params[:id])
  @cc.destroy
  flash[:notice] = "CC successfully deleted."
  redirect '/cc/view'
end


get '/cc/note/:id' do
  login_required!

  @cc = Cc.find_by(id: params[:id])

  haml :'ccs/note'
end

# Adds a note based on the id of the CC. All notes have dates on them. New
# notes are added at the top with a line break.
post '/cc/note/:id' do
  login_required!

  if params[:note].blank?
    flash[:error] = "A note is needed."
    redirect "/cc/note/#{ params[:id] }"
  else
    @cc = Cc.find_by(id: params[:id])

    if @cc == nil
      flash[:error] = "Invalid ID."
      redirect "/cc/note/#{ params[:id] }"
    elsif @cc.notes.blank?
      @cc.notes = "#{ Date.today }: #{ params[:note] } (by #{ current_user[:name] })"
    else
      temp = @cc.notes
      @cc.notes = "#{ Date.today }: #{ params[:note] } (by #{ current_user[:name] })<br>#{ temp }"
    end

    @cc.save
    flash[:notice] = "Note successfully added to #{ @cc.full_name }."
    redirect "/cc/show/#{ params[:id] }"
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

  params[:state].capitalize!
  params[:state_abb].upcase!

  arr.each do |x|
    @state.send(:"#{ x }=", params[:"#{ x }"])
  end

  @state.save
  flash[:notice] = "State successfully created."
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
  flash[:notice] = "State successfully saved."
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

  flash[:notice] = "State successfully deleted."
  redirect '/state/view'
end
