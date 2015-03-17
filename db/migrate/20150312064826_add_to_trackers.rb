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
    add_column :trackers, :instructions_for_editor_final, :string
    add_column :trackers, :impact_video_status, :string
    add_column :trackers, :impact_video_necessities, :string
    add_column :trackers, :impact_video_approved, :string
    add_column :trackers, :impact_video_approved_by, :string
    add_column :trackers, :call_to_action_review, :string
    add_column :trackers, :footage_location, :string
    rename_column :trackers, :screening_notes, :screening_details
    rename_column :trackers, :final_review_notes, :instructions_for_editor_edit
    remove_column :trackers, :review_notes, :string
    remove_column :trackers, :edited_video_rating, :string
    remove_column :trackers, :impact_status, :string
    remove_column :trackers, :official_screening_notes, :string
    remove_column :trackers, :stalin_notes, :string
    remove_column :trackers, :impact_review, :string
    remove_column :trackers, :impact_approval_date, :string
    remove_column :trackers, :impact_followup, :string
    remove_column :trackers, :impact_followup_notes, :string
    remove_column :trackers, :impact_reviewer, :string
  end
end
