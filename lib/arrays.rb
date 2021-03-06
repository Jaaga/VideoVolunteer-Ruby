# Array setters for sets that are used multiple times. This is used to show,
# edit and create new columns for trackers.

module Arrays

  # Set an array with all the column names
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
    status = ['footage_location', 'footage_received_from_cc_date',
              'raw_footage_review_date', 'state_edit_date',
              'edit_received_in_goa_date', 'rough_cut_edit_date',
              'review_date', 'finalized_date', 'youtube_date',
              'iu_publish_date', 'backup_received_date',
              'extra_footage_received_date']
    # Raw footage review
    review = ['community_participation_description', 'broll', 'interview',
              'voice_over', 'video_diary', 'p2c', 'translation_info',
              'proceed_with_edit_and_payment', 'cc_last_steps_for_payment',
              'call_to_action_review']
    footage_edit = ['editor_currently_in_charge', 'folder_title',
                    'instructions_for_editor_edit', 'editor_notes']
    footage_review = ['reviewer_name', 'editor_changes_needed',
                      'instructions_for_editor_final',
                      'publishing_suggestions', 'cc_feedback',
                      'subtitle_info', 'high_potential',
                      'youtube_url', 'video_title', 'cleared_for_edit']
    impact_planning = ['impact_possible', 'call_to_action', 'desired_change',
                       'impact_plan', 'target_official',
                       'target_official_email', 'target_official_phone',
                       'impact_process', 'milestone', 'impact_progress']
    impact_achieved = ['impact_achieved', 'impact_achieved_description',
                       'impact_date', 'impact_verified_by', 'people_involved',
                       'people_impacted', 'villages_impacted','impact_time',
                       'collaborations', 'important_impact']
    impact_video = ['impact_video_status', 'impact_video_necessities',
                    'impact_video_approved', 'impact_video_approved_by',
                    'impact_video_notes']
    screening = ['screening_done', 'screened_on', 'officials_at_screening',
                 'screening_headcount', 'officials_at_screening_number',
                 'officials_involved', 'screening_details']
    payment = ['payment_status']
    ratings = ['footage_rating', 'final_video_rating']
    extra = ['impact_uid', 'original_uid', 'no_original_uid', 'note', 'flag',
             'flag_notes', 'flag_date', 'updated_by', 'created_at', 'updated_at']
    special = ['footage_location', 'iu_theme', 'subcategory', 'story_type',
               'project', 'campaign',
               'proceed_with_edit_and_payment', 'payment_status',
               'subtitle_info', 'editor_changes_needed', 'translation_info',
               'screened_on', 'impact_video_status',
               'editor_currently_in_charge', 'impact_verified_by',
               'impact_video_approved_by', 'reviewer_name']
    yesno = ['high_potential', 'impact_possible',
             'impact_achieved', 'screening_done', 'officials_at_screening',
             'cleared_for_edit', 'impact_video_approved']
    numbers = ['people_involved', 'people_impacted', 'villages_impacted',
               'screening_headcount', 'officials_at_screening_number']

    return { story: story, status: status, footage_edit: footage_edit,
             footage_review: footage_review, review: review,
             impact_planning: impact_planning, impact_achieved: impact_achieved,
             impact_video: impact_video , screening: screening, payment: payment,
             ratings: ratings, extra: extra, special: special, yesno: yesno,
             numbers: numbers }
  end

  # Sets the arrays of column names for the User model
  def user_array_set
    new_user = ['email', 'password', 'password_verify', 'first_name', 'last_name']
    user = ['email', 'encrypted_password', 'first_name', 'last_name', 'full_name',
            'access', 'verified']

    return { new_user: new_user, user: user }
  end

  # Sets the array of column names for the CC model
  def cc_array_set
    ['first_name', 'last_name', 'state_abb', 'state', 'district', 'phone', 'mentor']
  end

  # Sets the array of column names for the State model
  def state_array_set
    ['state', 'state_abb']
  end

  def employee_set
    sc = ['Uttar Pradesh', 'Orissa', 'Bihar', 'Jharkhand',
          'Maharashtra', 'Jammu and Kashmir', 'Chattisgarh', 'Madhya Pradesh']

    editor = ['Sanjay Parmar', 'Dheeraj Sharma', 'Guruprasad Pednekar',
              'Kamar Sayeed', 'Shobha Ajay', 'Debaranjan Sarangi',
              'Kanhaiya Maurya', 'Zuhaib Ashraf', 'Deepak Bara',
              'Raviraj Naik', 'Ashok']

    return {sc: sc, editor: editor}
  end
end
