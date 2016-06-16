@CirclezAndSquares = (($) ->
  MAX_IDLE = 3
  NUM_CHANGES_FOR_DIRTY = 10
  SHAPE = 's'
  CIRCLE = 0
  SQUARE = 1
  TOP = 't'
  BOTTOM = 'b'
  LEFT = 'l'
  RIGHT = 'rt'

  sprites = {}
  latestId = 0
  grow_interval_id = 0
  intro = true
  changes_added = 0
  idle_time = 0
  idle_interval_id = 0

  $.fn.startGrowing = ->
    $this = $(@[0])
    if !$this
      return false
    bigEnough = false
    stopGrowing()
    grow_interval_id = setInterval((->
      thisI = getInfo($this)
      for key of sprites
        if key == $this.attr('id')
          continue
        otherI = sprites[key]
        if bigEnough = collide(thisI, otherI)
          break
      if !bigEnough
        makeBigger $this
      return
    ), 25)
    return

  registerObject = (obj) ->
    pos = obj.offset()
    height = obj.height()
    width = height
    radius = width / 2
    objId = obj.attr('id')
    sprites[objId] =
      s: if obj.hasClass('circle') then CIRCLE else SQUARE
      t: pos.top
      b: pos.top + height
      l: pos.left
      rt: pos.left + width
      x: pos.left + radius
      y: pos.top + radius
      r: radius
    return

  timerIncrement = ->
    if dirty()
      idle_time++
      if idle_time >= MAX_IDLE
        idle_time = 0
        saveDrawing()
    return

  registerObjects = ->
    $('.circle, .square').not('.prototype').each ->
      latestId++
      registerObject $(this).attr('id', latestId)
      return
    return

  registerChange = ->
    changes_added++
    idle_time = 0
    if dirty() and $('#like').is(':visible')
      $('#based_on').fadeIn 'fast'
      $('#based_on_link').html($('#name').html()).attr 'href', $('#name').attr('href')
      $('#name').html ''
      $('#like, #likes').fadeOut 'fast'
    return

  hideIntro = ->
    if intro
      intro = false
      $('#intro').fadeOut 1000
    return

  createObject = (e) ->
    shape = if e.shiftKey then 'square' else 'circle'
    latestId++
    $('.' + shape + '.prototype').clone().removeClass('prototype').attr('id', latestId).appendTo('body').css(
      top: e.pageY - 2
      left: e.pageX - 2).show()
    obj = $('#' + latestId)
    registerObject obj
    obj

  stopGrowing = ->
    clearInterval grow_interval_id
    idle_time = 0
    return

  dirty = ->
    changes_added >= NUM_CHANGES_FOR_DIRTY

  getInfo = (obj) ->
    sprites[obj.attr('id')]

  collide = (a, b) ->
    if a[SHAPE] == CIRCLE
      if b[SHAPE] == CIRCLE
        # circle and circle
        (b.x - (a.x)) * (b.x - (a.x)) + (a.y - (b.y)) * (a.y - (b.y)) <= (a.r + b.r + 4) * (a.r + b.r + 4)
      else
        # circle and square
        circleCollidesSquare a, b
    else
      if b[SHAPE] == CIRCLE
        # square and circle
        circleCollidesSquare b, a
      else
        # square and square
        a[LEFT] < b[RIGHT] + 4 and a[RIGHT] > b[LEFT] - 4 and a[TOP] < b[BOTTOM] + 4 and a[BOTTOM] > b[TOP] - 4

  circleCollidesSquare = (circle, square) ->
    closestX = clamp(circle.x, square[LEFT], square[RIGHT])
    closestY = clamp(circle.y, square[TOP], square[BOTTOM])
    distanceX = circle.x - closestX
    distanceY = circle.y - closestY
    distanceX * distanceX + distanceY * distanceY < (circle.r + 4) * (circle.r + 4)

  makeBigger = (obj) ->
    obj.css
      top: obj.offset().top - 1
      left: obj.offset().left - 1
      width: obj.width() + 2
      height: obj.height() + 2
    registerObject obj
    return

  removeObject = (obj) ->
    stopGrowing()
    delete sprites[obj.attr('id')]
    obj.remove()
    return

  saveDrawing = ->
    sprite_data = []
    for key of sprites
      sprite_data.push
        s: sprites[key].s
        t: sprites[key].t
        l: sprites[key].l
        d: sprites[key].r * 2
    name = prompt('What should we call this thing?')
    if name != null
      $.ajax(
        url: '/drawings'
        type: 'POST'
        data: drawing:
          name: name
          sprites_json: JSON.stringify(sprite_data)
          based_on: $('#here').html()).done (response) ->
        changes_added = 0
        $('#name').html(response.name).attr 'href', response.url
        document.location = response.url
        return
    return

  clamp = (x, a, b) ->
    Math.min Math.max(x, a), b

  $(document).ready ->
    registerObjects()
    if $('#background').length
      idle_interval_id = setInterval(timerIncrement, 60000)
      # 1 minute
    $('#background').click (e) ->
      hideIntro()
      createObject(e).startGrowing()
      registerChange()
      return
    $('body').on('mouseenter', '.circle, .square', ->
      $(this).startGrowing()
      return
    ).on('mouseleave', '.circle, .square', ->
      stopGrowing()
      return
    ).on('click', '.circle, .square', ->
      removeObject $(this)
      return
    ).on 'mousemove', '#background', ->
      stopGrowing()
      return
    $('#save').click ->
      if !dirty()
        alert 'You can put a little more time in than that...'
        return false
      saveDrawing()
      false
    $('.check_if_dirty').click ->
      if dirty()
        if !confirm('Leave without saving?')
          return false
      return
    $('#like').click ->
      if !$(this).hasClass('liked')
        $.get '/drawings/like/' + $('#here').html()
        $(this).addClass 'liked'
        $('#likes').html(Number($('#likes').text()) + 1).show()
      false
    return

) jQuery
