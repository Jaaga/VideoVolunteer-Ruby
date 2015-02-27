require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'
# For showing input errors.
require 'sinatra/flash'
require 'haml'
require './.config/environment'
require 'date'

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
    num = Array.new
    p @temp
    if !@temp.empty?
      # Save each UID in an array
      @temp.each do |x|
        num.push(x.uid)
      end
      p num
      # Sort it then save the highest number
      num.sort!
      num = num[num.length - 1].split('_')
      id = num[1].to_i + 1

      # Make unique UID from state abbreviation and newly created number
      @track.uid = "#{@cc.state_abb}_#{id.to_s}"
    else
      @track.uid = "#{@cc.state_abb}_1001"
    end

    # Fill in information from chosen cc
    @track.state = @cc.state
    @track.district = @cc.district
    @track.mentor = @cc.mentor

    arr = ['cc_name', 'iu_theme', 'subcategory', 'description', 'story_type', 'shoot_plan', 'story_rating',  'editor', 'edit_status', 'payment_status', 'description', 'folder_title', 'review_notes', 'edited_video_rating', 'youtube_url', 'video_title', 'subtitle_info', 'subtheme', 'project', 'reviewer_name', 'editor_changes_needed', 'cc_feedback', 'publishing_suggestions', 'final_video_rating', 'stalin_notes', 'video_type',   'impact_possible', 'target_official', 'target_official_email', 'target_official_phone', 'desired_change', 'impact_plan', 'impact_followup', 'impact_followup_notes', 'impact_uid', 'impact_process', 'impact_status', 'milestone', 'impact_time', 'collaborations', 'people_involved', 'people_impacted', 'villages_impacted', 'impact_production_status', 'impact_review', 'payment_approved', 'impact_reviewer',  'screening_done', 'screening_headcount', 'screening_notes', 'official_involved', 'officials_at_screening_number', 'officials_at_screening', 'official_screening_notes', 'flag', 'flag_notes', 'note']
    dates = ['story_pitch_date', 'received_cc_date', 'edit_in_goa_date', 'state_rough_cut_date', 'goa_rough_cut_date', 'raw_footage_review_date', 'backup_received_date', 'state_edit_date', 'edit_received_date', 'rough_cut_edit_date', 'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date', 'impact_date', 'impact_approval_date']

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
  @track = Tracker.where(:updated_at => Date.today-14...Date.today+1).order("updated_at DESC")
  @title = 'Recent Stories'

  haml :results
end


# Search Function

get '/search' do
  haml :search
end

post '/search' do
  arr = ['uid', 'state', 'district', 'mentor', 'cc_name', 'iu_theme', 'subcategory', 'description', 'story_type', 'shoot_plan', 'story_rating',  'editor', 'edit_status', 'payment_status', 'description', 'folder_title', 'review_notes', 'edited_video_rating', 'youtube_url', 'video_title', 'subtitle_info', 'subtheme', 'project', 'reviewer_name', 'editor_changes_needed', 'cc_feedback', 'publishing_suggestions', 'final_video_rating', 'stalin_notes', 'video_type',   'impact_possible', 'target_official', 'target_official_email', 'target_official_phone', 'desired_change', 'impact_plan', 'impact_followup', 'impact_followup_notes', 'impact_uid', 'impact_process', 'impact_status', 'milestone', 'impact_time', 'collaborations', 'people_involved', 'people_impacted', 'villages_impacted', 'impact_production_status', 'impact_review', 'payment_approved', 'impact_reviewer',  'screening_done', 'screening_headcount', 'screening_notes', 'official_involved', 'officials_at_screening_number', 'officials_at_screening', 'official_screening_notes', 'flag_notes', 'note']
  dates = ['story_pitch_date', 'received_cc_date', 'edit_in_goa_date', 'state_rough_cut_date', 'goa_rough_cut_date', 'raw_footage_review_date', 'backup_received_date', 'state_edit_date', 'edit_received_date', 'rough_cut_edit_date', 'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date', 'impact_date', 'impact_approval_date']

  data = Array.new
  index = Array.new
  search = Array.new

  if params[:flag] == "on"
    data.push("'priority'")
    index.push("flag")
  end

  arr.each do |x|
    if !params[:"#{x}"].blank?
      data.push("'#{params[:"#{x}"]}'")
      index.push(x)
    end
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

  haml :edit
end

post '/edit/:uid' do
  @track = Tracker.find_by(uid: params[:uid])
  arr = ['state', 'cc_name', 'district', 'mentor', 'iu_theme', 'subcategory', 'description', 'story_type', 'shoot_plan', 'story_rating',  'editor', 'edit_status', 'payment_status', 'description', 'folder_title', 'review_notes', 'edited_video_rating', 'youtube_url', 'video_title', 'subtitle_info', 'subtheme', 'project', 'reviewer_name', 'editor_changes_needed', 'cc_feedback', 'publishing_suggestions', 'final_video_rating', 'stalin_notes', 'video_type',   'impact_possible', 'target_official', 'target_official_email', 'target_official_phone', 'desired_change', 'impact_plan', 'impact_followup', 'impact_followup_notes', 'impact_uid', 'impact_process', 'impact_status', 'milestone', 'impact_time', 'collaborations', 'people_involved', 'people_impacted', 'villages_impacted', 'impact_production_status', 'impact_review', 'payment_approved', 'impact_reviewer',  'screening_done', 'screening_headcount', 'screening_notes', 'official_involved', 'officials_at_screening_number', 'officials_at_screening', 'official_screening_notes', 'flag', 'flag_notes', 'note']
  dates = ['story_pitch_date', 'received_cc_date', 'edit_in_goa_date', 'state_rough_cut_date', 'goa_rough_cut_date', 'raw_footage_review_date', 'backup_received_date', 'state_edit_date', 'edit_received_date', 'rough_cut_edit_date', 'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date', 'impact_date', 'impact_approval_date']

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

    @track.flag_notes = "#{Date.today}: #{params[:note]}"
    @track.flag = "priority"

    @track.save

    redirect '/recent'
  end
end

get '/unflag/:uid' do
  @track = Tracker.find_by(uid: params[:uid])

  @track.flag = nil
  @track.flag_notes = nil

  @track.save

  redirect '/recent'
end


# Making notes on correspondents

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
