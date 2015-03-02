# Form generators for forms and showing database tables.

module Forms
  # For displaying a tracker's information in get /show/:uid
  def show(track, columns)
    columns.map do |x|
      "<tr><th>#{ name_modifier(x) }</th><td>#{ track.send(:"#{ x }") }</td></tr>"
    end.join
  end

end
