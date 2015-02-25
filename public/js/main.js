$(document).ready(function() {

  // Toggles forms and information display for each major section (footage, impact, etc)

  $(".glyphicon-plus").click(function() {
    $(this).next().toggleClass("hide-list");
  })

  //
  // JQuery for results.haml
  //

  // Code to toggle display of checkboxes
  $(".glyphicon-th-list").click(function() {
    $(".checks ul").toggleClass("hide-list");
  });

  // Checboxes for column display
  $("input:checkbox:not(:checked)").each(function() {
    var column = $(".col" + this.className);
    $(column).hide();
  });

  $("input:checkbox").click(function(){
    var column = $(".col" + this.className);
    $(column).toggle();
  });

  // Table sorting
  $('th').click(function(){
    var table = $(this).parents('table').eq(0)
    var rows = table.find('tr:gt(0)').toArray().sort(comparer($(this).index()))
    this.asc = !this.asc
    if (!this.asc){rows = rows.reverse()}
    for (var i = 0; i < rows.length; i++){table.append(rows[i])}
  });

  function comparer(index) {
    return function(a, b) {
        var valA = getCellValue(a, index), valB = getCellValue(b, index)
        return $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.localeCompare(valB)
    }
  }

  function getCellValue(row, index){
    return $(row).children('td').eq(index).html()
  }
});
