window.Yumster or= {}
window.Yumster.MapMarkers or= {}
window.Yumster.MarkerSprite or= {}

class MapMarkers

  @CLUSTER_PERCENT = .1

  constructor: () ->
    @markers = []

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude
  makeMarker: (config) ->
    new google.maps.Marker config

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
          icon: window.Yumster.MarkerSprite.makeMarkerImage(window.Yumster.MarkerSprite.MARKER_CLUSTER_ORDINAL)
        }
        clustermarkers.push clustermarker
        for mk in cluster
          clustered.push mk
    unclusteredmarkers = (marker for marker in markers when clustered.indexOf(marker) == -1)
    return [unclusteredmarkers, clustermarkers]

$ ->
  window.Yumster.MapMarkers = new MapMarkers
  window.Yumster._MapMarkers = MapMarkers
