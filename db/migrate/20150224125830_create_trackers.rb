class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.string	:uid,             null: false, unique: true
      t.string	:state
      t.string	:cc_name
      t.string	:district
      t.string  :mentor
      t.string	:iu_theme
      t.string	:subcategory
      t.string	:description
      t.string	:story_type
      t.string	:shoot_plan
      t.string  :footage_rating
      t.date	  :story_pitch_date
      t.string	:editor_currently_in_charge
      t.string	:proceed_with_edit_and_payment
      t.string	:payment_status
      t.string	:description
      t.string	:folder_title
      t.string	:review_notes
      t.string	:edited_video_rating
      t.string	:youtube_url
      t.string	:video_title
      t.string	:subtitle_info
      t.string	:project
      t.string	:reviewer_name
      t.string	:editor_changes_needed
      t.string  :final_review_notes
      t.string  :high_potential
      t.string  :community_participation_description
      t.string  :broll
      t.string  :interview
      t.string  :voice_over
      t.string  :video_diary
      t.string  :p2c
      t.string	:cc_feedback
      t.string	:publishing_suggestions
      t.string	:final_video_rating
      t.string	:stalin_notes
      t.date	  :footage_received_from_cc_date
      t.date	  :story_date
      t.date	  :raw_footage_review_date
      t.date	  :backup_received_date
      t.date	  :state_edit_date
      t.date	  :edit_received_in_goa_date
      t.date	  :rough_cut_edit_date
      t.date	  :review_date
      t.date	  :finalized_date
      t.date	  :youtube_date
      t.date  	:iu_publish_date
      t.string	:impact_possible
      t.string	:target_official
      t.string	:target_official_email
      t.string	:target_official_phone
      t.string	:desired_change
      t.string	:impact_plan
      t.string	:impact_followup
      t.string	:impact_followup_notes
      t.string	:impact_uid
      t.string  :original_uid
      t.string	:impact_process
      t.string	:impact_status
      t.string  :impact_video_notes
      t.string  :important_impact
      t.string  :impact_achieved
      t.string  :impact_achieved_description
      t.string	:milestone
      t.string	:impact_time
      t.string	:collaborations
      t.string	:people_involved
      t.string	:people_impacted
      t.string	:villages_impacted
      t.string	:impact_review
      t.string	:impact_reviewer
      t.date  	:impact_date
      t.date  	:impact_approval_date
      t.string	:screening_done
      t.string	:screening_headcount
      t.string	:screening_notes
      t.string	:officials_involved
      t.string	:officials_at_screening_number
      t.string	:officials_at_screening
      t.string	:official_screening_notes
      t.string	:flag
      t.string	:flag_notes
      t.date    :flag_date
      t.text  	:note
      t.string  :updated_by

      t.timestamps
    end

    # Index for faster location of uid in table.
    add_index :trackers, :uid, unique: true
  end
end
