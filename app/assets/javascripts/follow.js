var mouseX = 0;
var mouseY = 0;
var $follower = null;
var xp = 0
var yp = 0;
var chasing = 0;
var speed = 10; // lower is faster
var distance = 15;
var $this = null;
var timeOut = 0;
var timeLimit = 30;
var movementX = 0;
var movementY = 0;
var calculatedDistance = {x: 0, y: 0}

$(document).ready(function() {
  $(document).mousemove(function(e) {
    mouseMoved = (mouseX != e.pageX);
    movementX = mouseX - e.pageX;
    movementY = mouseY - e.pageY;
    findDistance();
    mouseX = e.pageX;
    mouseY = e.pageY;
  });

  $('.browse a').mouseenter(function() {
    $this = $(this);
    $this.attr('z-index', 99999999);
    chase($('#balloon').stop().fadeIn('fast'));
  }).mouseleave(function() {
    stopChasing();
  });

  $balloon = $('#balloon');
  function chase(follower) {
    $follower = follower;
    $follower.css('background-image', "url('/assets/drawings/"+$this.attr('data-id')+".jpg')");
    clearInterval(chasing);
    chasing = setInterval(function() {
      timeOut++;
      if(movementX != 0) { timeOut = 0; }
      if (timeOut >= timeLimit) { stopChasing(); }
      xp += ((mouseX - xp + calculatedDistance.x) / speed) ;
      yp += ((mouseY - yp + calculatedDistance.y) / speed) ;
      $balloon.css({left: xp, top: yp});
    }, 30);
  }
});

function findDistance() {
  if (Math.abs(movementY) > 3) {
    if (movementY < 0) {
      calculatedDistance.y = -1 * (distance + $follower.width());
    }
    if (movementY > 0) {
      calculatedDistance.y = distance;
    }
  }
  if (Math.abs(movementY) > 3) {
    if (movementX < 0) {
      calculatedDistance.x = -1 * (distance + $follower.width());
    }
    if (movementX > 0) {
      calculatedDistance.x = distance;
    }
  }
}

function stopChasing() {
  $this.attr('z-index', 10);
  $follower.stop().fadeOut('fast', function() {
    timeOut = 0;
    clearInterval(chasing);
  });
}
function lineThroughCircle(x, y, circleX, circleY, r) {
  var closestX  = clamp(circleX, x, y);
  var closestY  = clamp(circleY, x, y);
  var distanceX = circleX - closestX;
  var distanceY = circleY - closestY;
  return (distanceX * distanceX) + (distanceY * distanceY) < ((circle.r + 4) * (circle.r + 4));
}

