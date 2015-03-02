# Array setters for sets that are used multiple times. This is used to show,
# edit and create new columns for trackers.

module Arrays

  def global_arr_set
    # Values creates a multidimensional array from the hash and removes the keys.
    # Make the global array based off of the other arrays.
    arr = main_set.values.flatten + extra_set.values.flatten
    return arr - ["edit_status", "payment_status", "subtitle_info",
                  "editor_changes_needed", "impact_status",
                  "impact_production_status", "flag", "flag_notes"]
  end

  def global_dates_set
    dates = date_set
    dates.delete(:extra_dates)
    return dates.values.flatten
  end

  def main_set
    story = ['iu_theme', 'subcategory', 'description', 'story_type', 'shoot_plan']
    footage = ['editor', 'folder_title', 'review_notes', 'youtube_url',
              'video_title', 'subtheme', 'project', 'reviewer_name',
              'cc_feedback', 'publishing_suggestions', 'stalin_notes', 'video_type']
    impact = ['impact_possible', 'target_official', 'target_official_email',
              'target_official_phone', 'desired_change', 'impact_plan',
              'impact_followup', 'impact_followup_notes', 'impact_uid',
              'impact_process', 'milestone', 'impact_time', 'collaborations',
              'people_involved', 'people_impacted', 'villages_impacted',
              'impact_review', 'payment_approved', 'impact_reviewer']
    screening = ['screening_done', 'screening_headcount', 'screening_notes',
                'official_involved', 'officials_at_screening_number',
                'officials_at_screening', 'official_screening_notes']
    extra = ['flag', 'flag_notes', 'updated_by']
    return { story: story, footage: footage, impact: impact, screening: screening, extra: extra }
  end

  def date_set
    story_dates = ['story_pitch_date']
    footage_dates = ['received_cc_date', 'edit_in_goa_date',
                    'state_rough_cut_date', 'goa_rough_cut_date']
    status_dates = ['backup_received_date', 'raw_footage_review_date',
                    'state_edit_date', 'edit_received_date', 'rough_cut_edit_date',
                    'review_date', 'finalized_date', 'youtube_date', 'iu_publish_date']
    impact_dates = ['impact_date', 'impact_approval_date']
    extra_dates = ['flag_date', 'created_at', 'updated_at']
    return { story_dates: story_dates, footage_dates: footage_dates,
              status_dates: status_dates, impact_dates: impact_dates, extra_dates: extra_dates }
  end

  def extra_set
    yes_no_impact = ['impact_possible', 'impact_followup', 'impact_review', 'payment_approved']
    yes_no_screening = ['screening_done', 'officials_at_screening']
    ratings = ['story_rating', 'edited_video_rating', 'final_video_rating']
    numbers_impact = ['people_involved', 'people_impacted', 'villages_impacted']
    numbers_screening = ['official_involved', 'officials_at_screening_number']
    return { yes_no_impact: yes_no_impact, yes_no_screening: yes_no_screening,
              ratings: ratings, numbers_impact: numbers_impact, numbers_screening: numbers_screening }
  end
end
