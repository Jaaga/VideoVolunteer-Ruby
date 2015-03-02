# Methods that are needed for display and id generation.

module Features
  def name_modifier(x)
    return x.split('_').map(&:capitalize).join(' ')
  end

  def uid_generate(temp, state_abb)
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

      # Make unique UID from state abbreviation and newly created number
      return "#{ state_abb }_#{ id.to_s }"
    else
      return "#{ state_abb }_1001"
    end
  end

end
