window.Yumster or= {}
window.Yumster.MapMarkers or= {}

class MapMarkers

  @SPRITE_XCOUNT: 24
  @SPRITE_XSIZE: 72
  @SPRITE_YSIZE: 84

  @MARKER_CLUSTER_ORDINAL: 26

  @CLUSTER_PERCENT = .1

  constructor: () ->
    @markers = []

  spriteOffsetsForOrdinal: (ordinal) ->
    xoffset = MapMarkers.SPRITE_XSIZE * Math.floor(ordinal / MapMarkers.SPRITE_XCOUNT)
    yoffset = MapMarkers.SPRITE_YSIZE * (ordinal % MapMarkers.SPRITE_XCOUNT)
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

  clear: () ->
    @markers = []

  addMarker: (lat, lng) ->
    latlng = @makeLatLng(lat, lng)
    marker = @makeMarker {
      position: latlng
    }
    @markers.push marker
    marker

  nearby: (marker, othermarker, distance) ->
    return (marker.getPosition().lat() > othermarker.getPosition().lat() - distance / 2) and
      (marker.getPosition().lat() < othermarker.getPosition().lat() + distance / 2) and
      (marker.getPosition().lng() > othermarker.getPosition().lng() - distance / 2) and
      (marker.getPosition().lng() < othermarker.getPosition().lng() + distance / 2)

  renderMarkersAndClusters: (mapboundary) ->
    cluster_size = mapboundary.toSpan().lat() * MapMarkers.CLUSTER_PERCENT
    clustermarkers = []
    markers = (marker for marker in @markers when mapboundary.contains(marker.getPosition()))
    clustered = []
    for marker, i in markers
      if clustered.indexOf(marker) >= 0
        continue
      cluster = [marker]
      for check, j in markers when j > i
        if @nearby(marker, check, cluster_size)
          cluster.push check
      if cluster.length > 1
        clustermarker = @makeMarker {
          position: cluster[0].getPosition()
          icon: @makeMarkerImage(MapMarkers.MARKER_CLUSTER_ORDINAL)
        }
        clustermarkers.push clustermarker
        for mk in cluster
          clustered.push mk
    unclusteredmarkers = (marker for marker in markers when clustered.indexOf(marker) == -1)
    return [unclusteredmarkers, clustermarkers]

$ ->
  window.Yumster.MapMarkers = new MapMarkers
  window.Yumster._MapMarkers = MapMarkers
