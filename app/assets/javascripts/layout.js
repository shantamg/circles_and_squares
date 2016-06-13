$(document).ready(function() {
  $('#switch').click(function() {
    $('body').toggleClass('invert');
    $.get('/invert');
    return false;
  });
});
