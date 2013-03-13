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

  makePoint: ([x, y]) ->
    new google.maps.Point(x, y)
  makeSize: (width, height) ->
    new google.maps.Size(width, height)

  makeMarkerIcon: (ordinal) ->
    if ordinal == MarkerSprite.MARKER_CLUSTER_ORDINAL
      return @clusterIcon()
    return @markerIcon(ordinal)

  markerIcon: (ord) -> {
    url: "/assets/marker-sprite.png"
    size: @makeSize(21, 34)
    origin: @makePoint(@spriteOffsetsForOrdinal(ord))
    anchor: @makePoint([11, 34])
  }

  clusterIcon: () -> {
    url: "/assets/marker-sprite.png"
    size: @makeSize(35, 26)
    origin: @makePoint(@spriteOffsetsForOrdinal(MarkerSprite.MARKER_CLUSTER_ORDINAL))
    anchor: @makePoint([17, 13])
  }

$ ->
  window.Yumster.MarkerSprite = new MarkerSprite
  window.Yumster._MarkerSprite = MarkerSprite
