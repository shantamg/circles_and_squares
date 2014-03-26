window.sprites = {}
window.latestId = 0;
window.iid = 0;

$(document).ready(function() {
  $('#background').click(function(e) {
    startGrowing(createObject(e));
  });
  $('body').on('mouseenter', '.circle, .square', function() {
    startGrowing($(this));
  }).on('mouseleave', '.circle, .square', function(){
    clearInterval(window.iid);
  }).on('click', '.circle, .square', function() {
    removeObject($(this));
  });
});

function createObject(e) {
  var shape = (e.altKey) ? 'square' : 'circle';
  window.latestId = window.latestId + 1;
  $('.'+shape+'.prototype').clone().removeClass('prototype').attr('id', 'id'+window.latestId).appendTo('body').css({
    top : e.pageY - 2,
    left : e.pageX - 2
  }).show();
  obj = $('#'+'id'+window.latestId);
  registerObject(obj);
  return obj;
}

function startGrowing($this) {
  var bigEnough = false;
  clearInterval(window.iid);
  window.iid = setInterval(function() {
    var thisI = getInfo($this);
    for(var key in window.sprites) {
      if (key == 'id'+$this.attr('id')) { continue; }
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
  return window.sprites['id'+obj.attr('id')];
}

function collide(a, b) {
  if (a.type == 'circle') {
    if (b.type == 'circle') { // circle and circle
      return (distance(a, b) < (a.r + b.r + 4))
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
  var circleDistanceX = Math.abs(circle.x - square.x);
  var circleDistanceY = Math.abs(circle.y - square.y);
  if (circleDistanceX > (square.r + circle.r) + 4) { return false; }
  if (circleDistanceY > (square.r + circle.r) + 4) { return false; }
  if (circleDistanceX <= square.r - 4) { return true; }
  if (circleDistanceY <= square.r - 4) { return true; }
  var cornerDist_sq = Math.pow((circleDistanceX - square.r), 2) + Math.pow((circleDistanceY - square.r), 2);
  return cornerDist_sq / Math.pow(circle.r, 2) <= 1.2;
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
  window.sprites['id'+objId] = {
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
  delete window.sprites['id'+obj.attr('id')];
  obj.remove();
}
