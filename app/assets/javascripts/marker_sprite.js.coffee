window.Yumster or= {}
window.Yumster.MarkerSprite or= {}

class MarkerSprite
  @SPRITE_XCOUNT: 24
  @SPRITE_XSIZE: 72
  @SPRITE_YSIZE: 84

  @MARKER_CLUSTER_ORDINAL: 26

  spriteOffsetsForOrdinal: (ordinal) ->
    xoffset = MarkerSprite.SPRITE_XSIZE * Math.floor(ordinal / MarkerSprite.SPRITE_XCOUNT)
    yoffset = MarkerSprite.SPRITE_YSIZE * (ordinal % MarkerSprite.SPRITE_XCOUNT)
    [xoffset, yoffset]

  makePoint: (x, y) ->
    new google.maps.Point(x, y)
  makeSize: (width, height) ->
    new google.maps.Size(width, height)
  makeMarkerImage: (ordinal) ->
    path = "/assets/marker-sprite.png"
    size = @makeSize(21, 34)
    [xoffset, yoffset] = @spriteOffsetsForOrdinal(ordinal)
    spritelocation = @makePoint(xoffset, yoffset)
    anchor = @makePoint(11, 34)
    new google.maps.MarkerImage(path, size, spritelocation, anchor)

$ ->
  window.Yumster.MarkerSprite = new MarkerSprite
  window.Yumster._MarkerSprite = MarkerSprite
