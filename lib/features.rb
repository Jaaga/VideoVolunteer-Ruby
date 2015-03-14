# Methods that are needed for display and id generation.

module Features
  # All columns have '_' for spaces and are lowercase. When the form and display
  # methods are used for various views, they iterate through column names, so
  # while this is being done, name_modifier is used to make titles by removing
  # the underscores and capitalizing each word.
  def name_modifier(x)
    # Uses the column name for the label unless another label is needed. Using
    # this hash to store the custom labels.
    labels = { 'description' => 'Description (one-liner and later youtube blurb)',
               'screening' => 'Screening (For impact only)',
               'no_original_uid' => 'Reason for not having original UID',
               'cc_feedback' => 'Feedback to give to CC',
               'impact_possible' => 'Impact Possible?',
               'editor_changes_needed' => 'Editor changes needed?',
               'impact_plan' => 'Impact plan advised to CC',
               'impact_process' => 'CC’s actual impact process and updates',
               'milestone' => 'Milestone achieved or aimed for (when complete impact not likely)',
               'important_impact' => 'Important impact? (If yes, why?)',
               'screening_done' => 'Community screening done?',
               'impact_progress' => 'What was the progress?',
               'cc_last_steps_for_payment' => 'What must cc do before the video will be cleared for payment?',
               'officials_at_screening' => 'Screening to official done?',
               'screening_headcount' => 'Number of community members at community screening',
               'officials_involved' => 'Names of officials involved',
               'officials_at_screening_number' => 'Number of officials the video has been shown to',
               'instructions_for_editor_edit' => 'Instrutions for editor',
               'instructions_for_editor_final' => 'Instrutions for editor after final review',
               'editor_notes' => "Editor's notes",
               'impact_date' => 'Date impact achieved',
               'impact_time' => 'Time it took to achieve the impact',
               'collaborations' => 'Who did the CC collaborate with to get the impact?',
               'impact_video_notes' => 'Other impact video notes' }
    unless labels[x].nil?
      return labels[x]
    else
      return x.split('_').map(&:capitalize).join(' ')
    end
  end

  # Generates a uid based on the state name and the last uid's number.
  def uid_generate(temp, state_abb, original)
    num = Array.new
    if !temp.empty?
      # Save each UID in an array
      temp.each do |x|
        num.push(x.uid)
      end
      # Sort it then save the highest number
      num.sort!
      num = num[num.length - 1].split('_')
      id = num[1].to_i + 1

      if original == 'yes'
        unless @track.original_uid.blank? then id = @track.original_uid.split('_').pop end
        return "#{ state_abb }_#{ id.to_s }_impact"
      else
        # Make unique UID from state abbreviation and newly created number
        return "#{ state_abb }_#{ id.to_s }"
      end
    else
      if original == 'yes'
        return "#{ state_abb }_1001_impact"
      else
        return "#{ state_abb }_1001"
      end
    end
  end

  def impact_uid_set(original)
    track = Tracker.find_by(uid: original)
    track.impact_uid = "#{ original }_impact"
    track.save
  end

  def login_required!
    if session[:user].nil?
      flash[:error] = 'Need to be logged in.'
      redirect '/login'
    end
  end

  def admin_required!
    login_required!
    user = current_user[:access]
    if user != 'admin'
      flash[:error] = 'Need to be admin.'
      redirect back
    end
  end

  def current_user
    if session[:user]
      user = User.find(session[:user])
      return { id: user.id, name: user.full_name, access: user.access,
               email: user.email }
    end
  end

  # Needs to be an admin and the current user logged in
  def right_user(id)
    if id.to_s != session[:user].to_s && current_user[:access] != 'admin'
      flash[:error] = 'Not authorized.'
      redirect back
    end
  end
end
