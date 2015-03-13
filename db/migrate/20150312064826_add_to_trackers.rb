class AddToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :campaign, :string
    add_column :trackers, :extra_footage_received_date, :date
    add_column :trackers, :call_to_action, :string
    add_column :trackers, :translation_info, :string
    add_column :trackers, :impact_verified_by, :string
    add_column :trackers, :no_original_uid, :string
    add_column :trackers, :screened_on, :string
    add_column :trackers, :editor_notes, :string
    add_column :trackers, :cleared_for_edit, :string
    add_column :trackers, :impact_progress, :string
    add_column :trackers, :cc_last_steps_for_payment, :string
    rename_column :trackers, :stalin_notes, :miscellaneous_notes
    rename_column :trackers, :final_review_notes, :instructions_for_editor
    remove_column :trackers, :review_notes, :string
    remove_column :trackers, :edited_video_rating, :string
    remove_column :trackers, :impact_status, :string
  end
end
