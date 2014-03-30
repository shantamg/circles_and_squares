// Constants
var MAX_IDLE = 3; // minutes
var NUM_CHANGES_FOR_DIRTY = 10;
var SHAPE  = 's';
var CIRCLE = 0;
var SQUARE = 1;
var TOP    = 't';
var BOTTOM = 'b';
var LEFT   = 'l';
var RIGHT  = 'rt';

// Globals
var sprites = {}
var latestId = 0;
var grow_interval_id = 0;
var intro = true;
var changes_added = 0;
var idle_time = 0;
var idle_interval_id = 0;

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
}

$(document).ready(function() {
  registerObjects();
  if ($('#background').length) {
    idle_interval_id = setInterval(timerIncrement, 60000); // 1 minute
  }
  $('#background').click(function(e) {
    hideIntro();
    createObject(e).startGrowing();
    registerChange();
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
    if (!dirty()) {
      alert("You can put a little more time in than that...");
      return false;
    }
    saveDrawing();
    return false;
  });
  $('.check_if_dirty').click(function() {
    if (dirty()) {
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

function timerIncrement() {
  if (dirty()) {
    idle_time++;
    if (idle_time >= MAX_IDLE) {
      idle_time = 0;
      saveDrawing();
    }
  }
}

function registerObjects() {
  $('.circle, .square').not('.prototype').each(function() {
    latestId++;
    registerObject($(this).attr('id', latestId));
  });
}

function registerChange() {
  changes_added++;
  idle_time = 0;
  if (dirty() && $('#like').is(':visible')) {
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
  grow_interval_id = setInterval(function() {
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
  clearInterval(grow_interval_id);
  idle_time = 0;
}

function dirty() {
  return changes_added >= NUM_CHANGES_FOR_DIRTY;
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
  var name = prompt("What should we call this thing?");
  if (name !== null) {
    $.ajax({
      url  : "/drawings",
      type : "POST",
      data : { drawing: {
        name         : name,
        sprites_json : JSON.stringify(sprite_data),
        based_on     : $('#here').html()
      } }
    }).done(function(response) {
      changes_added = 0;
      $('#name').html(response.name).attr('href', response.url);
      document.location = response.url;
    });
  }
}

function clamp(x, a, b) {
  return Math.min(Math.max(x, a), b);
}
