var sprites = {}
var latestId = 0;
var iid = 0;
var intro = true;
var dirty = false;
var clicks = 0;

var SHAPE  = 's';
var CIRCLE = 0;
var SQUARE = 1;
var TOP    = 't';
var BOTTOM = 'b';
var LEFT   = 'l';
var RIGHT  = 'rt';

function registerObject(obj) {
  var pos    = obj.offset();
  var height = obj.height();
  var width  = height;
  var radius = width / 2;
  var objId  = obj.attr('id');
  sprites[objId] = {
    s  : obj.hasClass('circle') ? CIRCLE : SQUARE,
    t  : pos.top,
    b  : pos.top + height,
    l  : pos.left,
    rt : pos.left + width,
    x  : pos.left + radius,
    y  : pos.top + radius,
    r  : radius
  }
  dirty = true;
}

$(document).ready(function() {
  registerObjects();
  dirty = false;
  $('#background').click(function(e) {
    hideIntro();
    createObject(e).startGrowing();
    registerClick();
  });
  $('body').on('mouseenter', '.circle, .square', function() {
    $(this).startGrowing();
  }).on('mouseleave', '.circle, .square', function(){
    stopGrowing();
  }).on('click', '.circle, .square', function() {
    removeObject($(this));
  }).on('mousemove', '#background', function() {
    stopGrowing();
  });
  $('#save').click(function() {
    if (clicks < 20) {
      alert("You can put a little more time in than that...");
      return false;
    }
    saveDrawing();
    return false;
  });
  $('.check_if_dirty').click(function() {
    if (dirty) {
      if (!confirm("Leave without saving?")) {
        return false;
      }
    }
  });
  $('#like').click(function() {
    if (!$(this).hasClass('liked')) {
      $.get('/drawings/like/'+$('#here').html());
      $(this).addClass('liked');
      $('#likes').html(Number($('#likes').text()) + 1).show();
    }
    return false;
  });
});

function registerObjects() {
  $('.circle, .square').not('.prototype').each(function() {
    latestId++;
    registerObject($(this).attr('id', latestId));
  });
}

function registerClick() {
  clicks++;
  if (clicks > 20 && $('#like').is(':visible')) {
    $('#based_on').fadeIn('fast');
    $('#based_on_link').html($('#name').html()).attr('href', $('#name').attr('href'));
    $('#name').html('');
    $('#like, #likes').fadeOut('fast');
  }
}

function hideIntro() {
  if (intro) {
    intro = false;
    $('#intro').fadeOut(1000);
  }
}

function createObject(e) {
  var shape = (e.shiftKey) ? 'square' : 'circle';
  latestId++;
  $('.'+shape+'.prototype').clone().removeClass('prototype').attr('id', latestId).appendTo('body').css({
    top : e.pageY - 2,
    left : e.pageX - 2
  }).show();
  obj = $('#'+latestId);
  registerObject(obj);
  return obj;
}

jQuery.fn.startGrowing = function() {
  var $this = $(this[0]);
  if (!$this) { return false; }
  var bigEnough = false;
  stopGrowing();
  iid = setInterval(function() {
    var thisI = getInfo($this);
    for(var key in sprites) {
      if (key == $this.attr('id')) { continue; }
      var otherI = sprites[key];
      if (bigEnough = collide(thisI, otherI)) { break; }
    };
    if (!bigEnough) {
      makeBigger($this);
    }
  }, 25);
}

function stopGrowing() {
  clearInterval(iid);
}

function getInfo(obj) {
  return sprites[obj.attr('id')];
}

function collide(a, b) {
  if (a[SHAPE] == CIRCLE) {
    if (b[SHAPE] == CIRCLE) { // circle and circle
      return ((b.x - a.x) * (b.x - a.x)) + ((a.y - b.y) * (a.y - b.y)) <= ((a.r + b.r + 4) * (a.r + b.r + 4));
    } else { // circle and square
      return circleCollidesSquare(a, b);
    }
  } else {
    if (b[SHAPE] == CIRCLE) { // square and circle
      return circleCollidesSquare(b, a);
    } else { // square and square
      return (a[LEFT] < b[RIGHT] + 4 && a[RIGHT] > b[LEFT] - 4 && a[TOP] < b[BOTTOM] + 4 && a[BOTTOM] > b[TOP] - 4);
    }
  }
}

function circleCollidesSquare(circle, square) {
  var closestX  = clamp(circle.x, square[LEFT], square[RIGHT]);
  var closestY  = clamp(circle.y, square[TOP], square[BOTTOM]);
  var distanceX = circle.x - closestX;
  var distanceY = circle.y - closestY;
  return (distanceX * distanceX) + (distanceY * distanceY) < ((circle.r + 4) * (circle.r + 4));
}

function makeBigger(obj) {
  obj.css({
    top    : obj.offset().top - 1,
    left   : obj.offset().left - 1,
    width  : obj.width() + 2,
    height : obj.height() + 2
  });
  registerObject(obj);
}

function removeObject(obj) {
  stopGrowing();
  delete sprites[obj.attr('id')];
  obj.remove();
  dirty = true;
}

function saveDrawing() {
  var sprite_data = [];
  for(var key in sprites) {
    sprite_data.push({
      s : sprites[key].s,
      t : sprites[key].t,
      l : sprites[key].l,
      d : sprites[key].r * 2
    });
  }
  var name = prompt("Please name this drawing:");
  $.ajax({
    url  : "/drawings",
    type : "POST",
    data : { drawing: {
      name         : name,
      sprites_json : JSON.stringify(sprite_data),
      based_on     : $('#here').html()
    } }
  }).done(function(response) {
    $('#name').html(response.name).attr('href', response.url);
    document.location = response.url;
  });
  dirty = false;
}

function clamp(x, a, b) {
  return Math.min(Math.max(x, a), b);
}
