# Form generators for forms and showing database tables.

module Forms
  # For displaying a tracker's information in get /show/:uid
  def show(track, columns)
    columns.map do |x|
      "<tr><th>#{ name_modifier(x) }</th><td>#{ track.send(:"#{ x }") }</td></tr>"
    end.join
  end

  def results_check(arr, count, checked = false)
    temp = Array.new
    if checked == false
      arr.map do |x|
        temp.push("<li><input class='#{ count }' type= 'checkbox'>
                   #{ name_modifier(x) }</input></li>")
        count += 1
      end
    else
      arr.map do |x|
        temp.push("<li><input class='#{ count }' type= 'checkbox'
                  checked= '#{checked}'>#{ name_modifier(x) }</input></li>")
        count += 1
      end
    end
    temp.join
  end

  def results_head(arr, count)
    temp = Array.new
    arr.map do |x|
      temp.push("<th class= 'col#{ count }'>#{ name_modifier(x) }</th>")
      count += 1
    end
    temp.join
  end

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
end
