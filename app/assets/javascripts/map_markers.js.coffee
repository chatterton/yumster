window.Yumster or= {}
window.Yumster.MapMarkers or= {}

class MapMarkers

  @SPRITE_XCOUNT: 24
  @SPRITE_XSIZE: 72
  @SPRITE_YSIZE: 84

  @MARKER_CLUSTER: 26

  constructor: (@clusterpercent = .10) ->
    @markers = []

  spriteOffsetsForOrdinal: (ordinal) ->
    xoffset = MapMarkers.SPRITE_XSIZE * Math.floor(ordinal / MapMarkers.SPRITE_XCOUNT)
    console.log xoffset
    yoffset = MapMarkers.SPRITE_YSIZE * (ordinal % MapMarkers.SPRITE_XCOUNT)
    console.log yoffset
    [xoffset, yoffset]

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude
  makeMarker: (config) ->
    new google.maps.Marker config
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

  placeMarkerOnMap: (ordinal, map, lat, lng) ->
    latlng = @makeLatLng(lat, lng)
    marker = @makeMarker {
      position: latlng
      map: map
      icon: @makeMarkerImage(ordinal)
    }
    marker

  clear: () ->
    @markers = []

  addMarker: (marker) ->
    @markers.push marker

  renderMarkersAndClusters: (map) ->
    bounds = map.getBounds()
    markers =[]
    clusters = []
    markers.push marker for marker in @markers when bounds.contains(marker.getPosition())
    return [markers, clusters]

$ ->
  window.Yumster.MapMarkers = new MapMarkers
  window.Yumster._MapMarkers = MapMarkers
