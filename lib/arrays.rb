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


  # All the columns segregated into display groups. The last three are used to
  # signal the form setting methods that certain columns need different input
  # types for data entry.
  def array_set
    story = ['iu_theme', 'subcategory', 'description', 'story_type', 'project',
             'shoot_plan', 'story_pitch_date']
    status = ['footage_received_from_cc_date', 'raw_footage_review_date',
              'state_edit_date', 'rough_cut_edit_date', 'edit_received_in_goa_date',
              'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date', 'backup_received_date']
    footage = ['editor_currently_in_charge', 'folder_title', 'edited_video_rating', 'reviewer_name',
               'editor_changes_needed', 'final_review_notes', 'publishing_suggestions', 'cc_feedback',
               'subtitle_info', 'stalin_notes',
               'proceed_with_edit_and_payment',
               'editor_changes_needed',
               'subtitle_info', 'high_potential',
               'review_notes', 'youtube_url', 'video_title']
    review = ['community_participation_description', 'broll', 'interview',
              'voice_over', 'video_diary', 'p2c']
    impact = ['impact_plan', 'impact_achieved_description', 'target_official', 'target_official_email', 'target_official_phone',
              'desired_change', 'impact_followup_notes',
              'impact_uid', 'original_uid', 'impact_process', 'milestone', 'impact_achieved', 'impact_time',
              'collaborations', 'impact_reviewer', 'impact_date',
              'impact_approval_date', 'impact_possible', 'impact_followup',
              'impact_review', 'people_involved', 'people_impacted',
              'villages_impacted', 'impact_status',
              'impact_video_notes', 'important_impact']
    screening = ['screening_done', 'screening_notes', 'official_screening_notes',
                 'officials_at_screening', 'screening_headcount', 'officials_involved',
                 'officials_at_screening_number']
    payment = ['payment_status']
    ratings = ['footage_rating', 'final_video_rating']
    extra = ['note', 'flag', 'flag_notes', 'updated_by', 'flag_date', 'created_at', 'updated_at']
    special = ['iu_theme', 'subcategory', 'story_type', 'proceed_with_edit_and_payment',
               'payment_status', 'subtitle_info', 'editor_changes_needed',
               'impact_status']
    yesno = ['high_potential', 'impact_possible', 'impact_followup', 'impact_review',
             'impact_achieved', 'screening_done', 'officials_at_screening']
    numbers = ['people_involved', 'people_impacted', 'villages_impacted',
               'screening_headcount', 'officials_involved', 'officials_at_screening_number']

    return { story: story, status: status, footage: footage, review: review, impact: impact,
            screening: screening, payment: payment, ratings: ratings, extra: extra, special: special,
            yesno: yesno, numbers: numbers }
  end

  def user_array_set
    new_user = ['email', 'password', 'password_verify', 'first_name', 'last_name']
    user = ['email', 'encrypted_password', 'first_name', 'last_name', 'full_name',
            'access', 'verify']

    return { new_user: new_user, user: user }
  end
end
