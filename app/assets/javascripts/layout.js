$(document).ready(function() {
  moveUser();
  $(window).resize(function() {
    moveUser();
  });
});

function moveUser() {
  if($('#menu').width() + $('#menu').offset().left > $('#user').offset().left - $('#user').width()) {
    $('#user').css({top: 'inherit', bottom: 0});
  } else {
    $('#user').css({top: 0, bottom: 'inherit'});
  }
}