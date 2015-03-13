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
             'campaign', 'shoot_plan', 'story_pitch_date']
    status = ['footage_received_from_cc_date', 'raw_footage_review_date',
              'state_edit_date', 'rough_cut_edit_date', 'edit_received_in_goa_date',
              'review_date', 'finalized_date', 'youtube_date',
              'iu_publish_date', 'backup_received_date', 'extra_footage_received_date']
    review = ['community_participation_description', 'broll', 'interview',
              'voice_over', 'video_diary', 'p2c', 'call_to_action', 'translation_info',
              'proceed_with_edit_and_payment']
    footage_edit = ['editor_currently_in_charge', 'folder_title',
                    'editor_changes_needed', 'editor_notes',
                    'instructions_for_editor', 'miscellaneous_notes']
    footage_review = ['reviewer_name',
                      'publishing_suggestions', 'cc_feedback',
                      'subtitle_info',
                      'subtitle_info', 'high_potential',
                      'youtube_url', 'video_title', 'cleared_for_edit',
                      'cc_last_steps_for_payment']
    impact_planning = ['impact_possible', 'desired_change', 'impact_plan',
                       'target_official',
                       'target_official_email', 'target_official_phone',
                       'impact_process', 'milestone',
                       'impact_progress']
    impact_achieved = ['impact_achieved', 'impact_achieved_description',
                       'impact_verified_by', 'people_involved', 'people_impacted',
                       'villages_impacted','impact_time',
                       'collaborations', 'impact_reviewer', 'impact_date',
                       'impact_approval_date',
                       'impact_review', 'important_impact',
                       'impact_followup',
                       'impact_followup_notes', 'impact_video_notes']
    screening = ['screening_done', 'screened_on', 'officials_at_screening',
                 'screening_headcount', 'officials_at_screening_number',
                 'officials_involved', 'screening_details']
    payment = ['payment_status']
    ratings = ['footage_rating', 'final_video_rating']
    extra = ['impact_uid', 'original_uid', 'no_original_uid', 'note', 'flag', 'flag_notes',
             'updated_by', 'flag_date', 'created_at', 'updated_at']
    special = ['iu_theme', 'subcategory', 'story_type', 'project', 'campaign', 'proceed_with_edit_and_payment',
               'payment_status', 'subtitle_info', 'editor_changes_needed',
               'translation_info', 'screened_on']
    yesno = ['high_potential', 'impact_possible', 'impact_followup', 'impact_review',
             'impact_achieved', 'screening_done', 'officials_at_screening',
             'cleared_for_edit']
    numbers = ['people_involved', 'people_impacted', 'villages_impacted',
               'screening_headcount', 'officials_at_screening_number']

    return { story: story, status: status, footage_edit: footage_edit,
             footage_review: footage_review, review: review, impact_planning: impact_planning,
             impact_achieved: impact_achieved, screening: screening, payment: payment, ratings: ratings,
             extra: extra, special: special, yesno: yesno, numbers: numbers }
  end

  def user_array_set
    new_user = ['email', 'password', 'password_verify', 'first_name', 'last_name']
    user = ['email', 'encrypted_password', 'first_name', 'last_name', 'full_name',
            'access', 'verified']

    return { new_user: new_user, user: user }
  end

  def cc_array_set
    ['first_name', 'last_name', 'state_abb', 'state', 'district', 'phone', 'mentor']
  end

  def state_array_set
    ['state', 'state_abb']
  end
end
