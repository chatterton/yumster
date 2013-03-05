window.Yumster or= {}
window.Yumster.MapMarkers or= {}

class MapMarkers

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude
  makeMarker: (config) ->
    new google.maps.Marker config

  createMarker: (ordinal, map, lat, lng) ->
    latlng = @makeLatLng(lat, lng)
    marker = @makeMarker {
      position: latlng
      map: map
      #icon: location.icon
    }
    marker

$ ->
  window.Yumster.MapMarkers = new MapMarkers
  window.Yumster._MapMarkers = MapMarkers
