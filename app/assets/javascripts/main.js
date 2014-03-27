window.sprites = {}
window.latestId = 0;
window.iid = 0;
window.intro = true;

$(document).ready(function() {
  $('#background').click(function(e) {
    hideIntro();
    startGrowing(createObject(e));
  });
  $('body').on('mouseenter', '.circle, .square', function() {
    startGrowing($(this));
  }).on('mouseleave', '.circle, .square', function(){
    clearInterval(window.iid);
  }).on('click', '.circle, .square', function() {
    removeObject($(this));
  }).on('mousemove', '#background', function() {
    clearInterval(window.iid);
  });
});

function hideIntro() {
  if (window.intro) {
    window.intro = false;
    $('#intro').fadeOut(1000);
  }
}

function createObject(e) {
  if (e.altKey) {
    alert(JSON.stringify(window.sprites));
    return false;
  }
  var shape = (e.shiftKey) ? 'square' : 'circle';
  window.latestId = window.latestId + 1;
  $('.'+shape+'.prototype').clone().removeClass('prototype').attr('id', window.latestId).appendTo('body').css({
    top : e.pageY - 2,
    left : e.pageX - 2
  }).show();
  obj = $('#'+window.latestId);
  registerObject(obj);
  return obj;
}

function startGrowing($this) {
  if (!$this) { return false; }
  var bigEnough = false;
  clearInterval(window.iid);
  window.iid = setInterval(function() {
    var thisI = getInfo($this);
    for(var key in window.sprites) {
      if (key == $this.attr('id')) { continue; }
      var otherI = window.sprites[key];
      if (bigEnough = collide(thisI, otherI)) { break; }
    };
    if (!bigEnough) {
      makeBigger($this);
    }
  }, 25);
}

function distance(a, b) {
  var vert = Math.abs(a.y - b.y);
  var horiz = Math.abs(a.x - b.x);
  return Math.sqrt((vert * vert) + (horiz * horiz));
}

function getInfo(obj) {
  return window.sprites[obj.attr('id')];
}

function collide(a, b) {
  if (a.type == 'circle') {
    if (b.type == 'circle') { // circle and circle
      return ((b.x - a.x) * (b.x - a.x)) + ((a.y - b.y) * (a.y - b.y)) <= ((a.r + b.r + 4) * (a.r + b.r + 4));
    } else { // circle and square
      return circleAndSquare(a, b);
    }
  } else {
    if (b.type == 'circle') { // square and circle
      return circleAndSquare(b, a);
    } else { // square and square
      return (a.left < b.right + 4 && a.right > b.left - 4 && a.top < b.bottom + 4 && a.bottom > b.top - 4);
    }

  }
}

function circleAndSquare(circle, square) {
  var closestX = clamp(circle.x, square.left, square.right);
  var closestY = clamp(circle.y, square.top, square.bottom);
  var distanceX = circle.x - closestX;
  var distanceY = circle.y - closestY;
  return (distanceX * distanceX) + (distanceY * distanceY) < ((circle.r + 4) * (circle.r + 4));
}

function makeBigger(obj) {
  obj.css({
    top :  obj.offset().top - 1,
    left : obj.offset().left - 1,
    width: obj.width() + 2,
    height: obj.height() + 2
  });
  registerObject(obj);
}

function registerObject(obj) {
  var pos = obj.offset();
  var radius = obj.height() / 2;
  var objId = obj.attr('id');
  window.sprites[objId] = {
    top : pos.top,
    bottom : pos.top + (radius * 2),
    left : pos.left,
    right : pos.left + (radius * 2),
    y : pos.top + radius,
    x : pos.left + radius,
    r : radius,
    type : obj.hasClass('circle') ? 'circle' : 'square'
  }
}

function removeObject(obj) {
  clearInterval(window.iid);
  delete window.sprites[obj.attr('id')];
  obj.remove();
}

function clamp(x, a, b) {
  return Math.min(Math.max(x, a), b);
}
