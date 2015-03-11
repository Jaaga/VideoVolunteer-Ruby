# Methods that are needed for display and id generation.

module Features
  # All columns have '_' for spaces and are lowercase. When the form and display
  # methods are used for various views, they iterate through column names, so
  # while this is being done, name_modifier is used to make titles by removing
  # the underscores and capitalizing each word.
  def name_modifier(x)
    return x.split('_').map(&:capitalize).join(' ')
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
