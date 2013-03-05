window.Yumster or= {}
window.Yumster.MapMarkers or= {}

class MapMarkers

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
    offset = 84 * ordinal
    spritelocation = @makePoint(0, offset)
    anchor = @makePoint(11, 34)
    new google.maps.MarkerImage(path, size, spritelocation, anchor)
  createMarker: (ordinal, map, lat, lng) ->
    latlng = @makeLatLng(lat, lng)
    marker = @makeMarker {
      position: latlng
      map: map
      icon: @makeMarkerImage(ordinal)
    }
    marker

$ ->
  window.Yumster.MapMarkers = new MapMarkers
  window.Yumster._MapMarkers = MapMarkers
