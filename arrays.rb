# Array setters for sets that are used multiple times.

module Arrays

  def global_arr_set
    return ['iu_theme', 'subcategory',
            'story_type', 'shoot_plan', 'story_rating',  'editor',
            'edit_status', 'payment_status', 'folder_title', 'review_notes',
            'edited_video_rating', 'youtube_url', 'video_title', 'subtitle_info',
            'subtheme', 'project', 'reviewer_name', 'editor_changes_needed',
            'cc_feedback', 'publishing_suggestions', 'final_video_rating',
            'stalin_notes', 'video_type', 'impact_possible', 'target_official',
            'target_official_email', 'target_official_phone', 'desired_change', 'impact_plan',
            'impact_followup', 'impact_followup_notes', 'impact_uid', 'impact_process',
            'impact_status', 'milestone', 'impact_time', 'collaborations', 'people_involved',
            'people_impacted', 'villages_impacted', 'impact_production_status', 'impact_review',
            'payment_approved', 'impact_reviewer',  'screening_done', 'screening_headcount',
            'screening_notes', 'official_involved', 'officials_at_screening_number',
            'officials_at_screening', 'official_screening_notes', 'note']
  end

  def global_dates_set
    return ['story_pitch_date', 'received_cc_date', 'edit_in_goa_date',
            'state_rough_cut_date', 'goa_rough_cut_date', 'raw_footage_review_date',
            'backup_received_date', 'state_edit_date', 'edit_received_date',
            'rough_cut_edit_date', 'review_date', 'finalized_date', 'youtube_date',
            'iu_publish_date', 'impact_date', 'impact_approval_date', 'flag_date']
  end

  def main_set(story, footage, impact, screening)
    # return ['iu_theme', 'subcategory', 'description', 'story_type', 'shoot_plan']
  end

  def date_set(story_dates, footage_dates, status_dates, impact_dates)
  end

  def extra_set(yes_no_impact, yes_no_screening, ratings, numbers_impact, numbers_screening)
  end
end
