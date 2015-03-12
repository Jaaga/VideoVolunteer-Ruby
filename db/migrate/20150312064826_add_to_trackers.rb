class AddToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :campaign, :string
    add_column :trackers, :extra_footage_received_date, :date
    add_column :trackers, :call_to_action, :string
    add_column :trackers, :translation_info, :string
    add_column :trackers, :impact_verified_by, :string
    add_column :trackers, :no_original_uid, :string
    add_column :trackers, :screened_on, :string
    remove_column :trackers, :edited_video_rating, :string
  end
end
