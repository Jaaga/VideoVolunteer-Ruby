# Form generators for forms and showing database tables.

module Forms
  # For displaying a tracker's information in get /show/:uid
  def show(track, columns)
    columns.map do |x|
      "<tr><td class = 'show-head'>#{ name_modifier(x) }</td>
      <td>#{ track.send(:"#{ x }") }</td></tr>"
    end.join
  end

  # For displaying the checkboxes on the results.haml page
  def results_check(arr, count, checked = false)
    temp = Array.new
    if checked == false
      arr.map do |x|
        temp.push("<li><input class='#{ count }' type= 'checkbox'>
                   #{ name_modifier(x) }</li>")
        count += 1
      end
    else
      arr.map do |x|
        temp.push("<li><input class='#{ count }' type= 'checkbox'
                  checked= '#{checked}'>#{ name_modifier(x) }</li>")
        count += 1
      end
    end
    temp.join
  end

  # For displaying the table headers on the results.haml page
  def results_head(arr, count)
    temp = Array.new
    arr.map do |x|
      temp.push("<th class= 'col#{ count }'>#{ name_modifier(x) }</th>")
      count += 1
    end
    temp.join
  end

  # For displaying the table cells on the results.haml page
  def results_body(arr, count, t)
    temp = Array.new
    arr.map do |x|
      temp.push("<td class = 'col#{ count }'>")
      temp.push(h t.send(:"#{ x }"))
      temp.push("</td>")
      count += 1
    end
    temp.join
  end

  # Used to set forms for new.haml and edit.haml . This method sets forms for text and date
  # fields, along with columns that require unique dropdowns. The second arg is
  # is passed so that special fields can be identified. number and yesno are for
  # identifying the fields that need a yes/no dropdown or an integer type but
  # are not easily identifiable by their column name. track is for edit.haml and
  # is used to display the original value of the column.
  def new_set(arr, special = [], number = [], yesno = [], track = nil)
    arr.map do |x|
      temp = track.send(:"#{ x }") if track != nil
      value = !temp.blank? ? temp : ''
      if special.include? x
        new_set_special([x], value)
      elsif number.include? x
        new_set_number([x], value)
      elsif yesno.include? x
        new_set_yesno([x], value)
      elsif x.include? '_date'
        "<div class = 'form-group'>
          <label class = 'col-sm-3 control-label'>#{ name_modifier(x) }:</label>
          <div class = 'col-sm-9'>
            <input class = 'form-control' type = 'date' name = #{ x } value =
            '#{ value }'></div></div>"
      elsif x.include? '_rating'
        "<div class = 'form-group'>
          <label class = 'col-sm-3 control-label'>#{ name_modifier(x) }:</label>
          <div class = 'col-sm-9'>
          <select name = '#{ x }'>
            <option selected = 'true' disabled = 'true' value = '#{ value }'>#{ value }</option>
            <option value = '1 - Poor'>1 - Poor (CC must reshoot)</option>
            <option value = '2 - Mediocre'>2 - Mediocre</option>
            <option value = '3 - Very Good'>3 - Very Good</option>
            <option value = '4 - One of the Best Videos I've Seen'>
              4 - One of the Best Videos I've Seen</option>
          </select></div></div>"
      else
        "<div class = 'form-group'>
          <label class = 'col-sm-3 control-label'>#{ name_modifier(x) }:</label>
          <div class = 'col-sm-9'>
            <input class = 'form-control' type = 'text' name = #{ x } value =
            '#{ value }'></div></div>"
      end
    end.join
  end

  # Set the forms for columns that only take in integers.
  # 'value = '#{ value }'' needs to be at the end of the tag in case value = nil.
  def new_set_number(arr, value = nil)
    arr.map do |x|
      "<div class = 'form-group'>
        <label class = 'col-sm-3 control-label'>#{ name_modifier(x) }:</label>
        <div class = 'col-sm-9'>
          <input class = 'form-control' type = 'number' name = #{ x } value =
          '#{ value }'></div></div>"
    end.join
  end

  # Set the forms for columns with yes/no dropdowns.
  def new_set_yesno(arr, value = nil)
    arr.map do |x|
      "<div class = 'form-group'>
        <label class = 'col-sm-3 control-label'>#{ name_modifier(x) }:</label>
        <div class = 'col-sm-9'><select name = '#{ x }'>
          <option selected = 'true' disabled = 'true' value = '#{ value }'>#{ value }</option>
          <option value = 'yes'>yes</option>
          <option value = 'no'>no</option></select></div></div>"
    end.join
  end

  # Set the forms for columns with specific dropdowns.
  # If the dropdowns aren't showing up, all[:special] may need to be added to
  # the haml render located in new.haml or edit.haml (special = [] for some).
  def new_set_special(arr, value = nil)
    arr.map do |x|
      if (x == 'iu_theme') || (x == 'subcategory')
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>
          #{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              #{ theme_set("#{x}") }
            </select>
          </div>
        </div>"
      elsif x == 'story_type'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>
          #{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              #{ theme_set("#{x}") }
            </select>
          </div>
        </div>"
      elsif x == 'project'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='None'>None</option>
              <option value='Oak'>Oak</option>
              <option value='Pacs'>Pacs</option>
            </select>
          </div>
        </div>"
      elsif x == 'campaign'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>
          #{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              #{ theme_set("#{x}") }
            </select>
          </div>
        </div>"
      elsif x == 'proceed_with_edit_and_payment'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='Cleared'>Cleared</option>
              <option value='On hold'>On hold</option>
            </select>
          </div>
        </div>"
      elsif x == 'payment_status'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='payment_status'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='Approved'>Approved</option>
              <option value='Paid'>Paid</option>
              <option value='Hold'>Hold</option>
            </select>
          </div>
        </div>"
      elsif x == 'subtitle_info'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='subtitle_info'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='Has subtitles'>Has subtitles</option>
              <option value='High priority subtitle'>High priority subtitle</option>
              <option value='Low priority subtitle'>Low priority subtitle</option>
              <option value='Don't subtitle'>Don't subtitle</option>
            </select>
          </div>
        </div>"
      elsif x == 'editor_changes_needed'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='editor_changes_needed'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='Required'>Required</option>
              <option value='Suggested'>Suggested</option>
              <option value='Not needed'>Not needed</option>
              <option value='No further edits required'>No further edits required</option>
            </select>
          </div>
        </div>"
      elsif x == 'translation_info'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>#{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='translation_info'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              <option value='Required'>Required</option>
              <option value='Needed and provided'>Needed and provided</option>
              <option value='Needed & not provided'>Needed & not provided</option>
            </select>
          </div>
        </div>"
      elsif x == 'screened_on'
        "<div class='form-group'>
          <label class='col-sm-3 control-label'>
          #{name_modifier(x)}:</label>
          <div class='col-sm-9'>
            <select name='#{ x }'>
              <option disabled selected value = '#{ value }'>#{ value }</option>
              #{ theme_set("#{x}") }
            </select>
          </div>
        </div>"
      end
    end.join
  end

  def theme_set(column)
    themes = ['Arts and Culture', 'Caste', 'Gender', 'Religion and Identity',
              'Indigenous People', 'Governance and Accountability',
              'Corruption', 'Health', 'Education', 'Livelihoods',
              'Food and Social Security', 'Water', 'Information Technology',
              'Environment', 'Roads and Public Works', 'Power and Energy',
              'Mining', 'State Repression', 'Forced Evictions', 'Sanitation',
              'Natural Disaster', 'Impact']

    types = ['Entitlement Violation', 'Newsworthy', 'Human Interest',
             'Human Rights Violation', 'CC Profile', 'Community Profile',
             'Mini-doc', 'Special Video', 'Success']

    campaigns = ['None', 'Anti-Untouchability', 'RTE', 'Forced Evictions',
                'Maternal Health', 'Violence Against Women']

    screens = ['tablet', 'video camera', 'laptop', 'DVD player', 'projector']

    if (column == 'iu_theme') || (column == 'subcategory')
      themes.map do |x|
        "<option value='#{ x }'>#{ x }</option>"
      end.join
    elsif column == 'story_type'
      types.map do |x|
        "<option value='#{ x }'>#{ x }</option>"
      end.join
    elsif column == 'campaign'
      campaigns.map do |x|
        "<option value='#{ x }'>#{ x }</option>"
      end.join
    elsif column == 'screened_on'
      screens.map do |x|
        "<option value='#{ x }'>#{ x }</option>"
      end.join
    end
  end
end
