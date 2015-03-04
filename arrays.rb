# Array setters for sets that are used multiple times. This is used to show,
# edit and create new columns for trackers.

module Arrays

  def global_arr_set
    # Values creates a multidimensional array from the hash and removes the keys.
    # Makes the global array based off of the other arrays so that all the
    # column names are in one place.
    arr = array_set.values.flatten
    return arr.uniq
  end

  def array_set
    story = ['iu_theme', 'subcategory', 'description', 'story_type',
             'shoot_plan', 'story_pitch_date']
    status = ['backup_received_date', 'raw_footage_review_date',
              'state_edit_date', 'edit_received_date', 'rough_cut_edit_date',
              'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date']
    footage = ['editor', 'folder_title', 'review_notes', 'youtube_url',
               'video_title', 'subtheme', 'project', 'reviewer_name',
               'cc_feedback', 'publishing_suggestions', 'stalin_notes', 'video_type',
               'received_cc_date', 'edit_in_goa_date', 'state_rough_cut_date',
               'goa_rough_cut_date', 'edit_status', 'payment_status',
               'subtitle_info', 'editor_changes_needed',
               'payment_status', 'subtitle_info', 'editor_changes_needed']
    impact = ['target_official', 'target_official_email', 'target_official_phone',
              'desired_change', 'impact_plan', 'impact_followup_notes',
              'impact_uid', 'original_uid', 'impact_process', 'milestone', 'impact_time',
              'collaborations', 'impact_reviewer', 'impact_date',
              'impact_approval_date', 'impact_possible', 'impact_followup',
              'impact_review', 'payment_approved', 'people_involved', 'people_impacted',
              'villages_impacted', 'impact_status', 'impact_production_status',
              'impact_video_notes', 'important_impact', 'impact_achieved']
    screening = ['screening_notes', 'official_screening_notes', 'screening_done',
                 'officials_at_screening', 'screening_headcount', 'officials_involved',
                 'officials_at_screening_number']
    ratings = ['story_rating', 'edited_video_rating', 'final_video_rating']
    extra = ['note', 'flag', 'flag_notes', 'updated_by', 'flag_date', 'created_at', 'updated_at']
    special = ['edit_status', 'payment_status', 'subtitle_info',
               'editor_changes_needed', 'impact_status', 'impact_production_status']
    yesno = ['impact_possible', 'impact_followup', 'impact_review',
             'payment_approved', 'impact_achieved', 'screening_done', 'officials_at_screening']
    numbers = ['people_involved', 'people_impacted', 'villages_impacted',
               'screening_headcount', 'officials_involved', 'officials_at_screening_number']

    return { story: story, status: status, footage: footage, impact: impact,
            screening: screening, ratings: ratings, extra: extra, special: special,
            yesno: yesno, numbers: numbers}
  end
end
