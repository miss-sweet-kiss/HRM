$(document).ready(function() {
  $('#celebTree table')
    .hide()
    .prev('span')
    .before('<span></span>')
    .prev()
    .addClass('handle closed')
    .click(function() {
      // plus/minus handle click
      $(this)
        .toggleClass('closed opened')
        .nextAll('tr')
        .toggle();
    });
});
