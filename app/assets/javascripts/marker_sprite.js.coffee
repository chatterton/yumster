window.Yumster or= {}
window.Yumster.MarkerSprite or= {}

class MarkerSprite
  @SPRITE_XCOUNT: 24
  @SPRITE_XSIZE: 70
  @SPRITE_YSIZE: 82

  @MARKER_XSIZE: 28
  @MARKER_YSIZE: 35

  @MARKER_CLUSTER: 26
  @CLUSTER_XSIZE: 36
  @CLUSTER_YSIZE: 31

  @MARKER_PLAIN: 27

  spriteOffsetsForOrdinal: (ordinal) ->
    xoffset = MarkerSprite.SPRITE_XSIZE * Math.floor(ordinal / MarkerSprite.SPRITE_XCOUNT)
    yoffset = MarkerSprite.SPRITE_YSIZE * (ordinal % MarkerSprite.SPRITE_XCOUNT)
    [xoffset, yoffset]

  makePoint: ([x, y]) ->
    new google.maps.Point(x, y)
  makeSize: (width, height) ->
    new google.maps.Size(width, height)

  makeMarkerIcon: (ordinal) ->
    if ordinal == MarkerSprite.MARKER_CLUSTER
      return @clusterIcon()
    return @markerIcon(ordinal)

  markerIcon: (ord) -> {
    url: "/assets/marker-sprite.png"
    size: @makeSize(MarkerSprite.MARKER_XSIZE, MarkerSprite.MARKER_YSIZE)
    origin: @makePoint(@spriteOffsetsForOrdinal(ord))
  }

  clusterIcon: () -> {
    url: "/assets/marker-sprite.png"
    size: @makeSize(MarkerSprite.CLUSTER_XSIZE, MarkerSprite.CLUSTER_YSIZE)
    origin: @makePoint(@spriteOffsetsForOrdinal(MarkerSprite.MARKER_CLUSTER))
    anchor: @makePoint([18, 16])
  }

$ ->
  window.Yumster.MarkerSprite = new MarkerSprite
  window.Yumster._MarkerSprite = MarkerSprite
