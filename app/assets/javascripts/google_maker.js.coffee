window.Yumster or= {}
window.Yumster.GoogleMaker or= {}

class GoogleMaker

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude

  makeMarker: (config) ->
    new google.maps.Marker config

  makeLatLngBounds: () ->
    new google.maps.LatLngBounds

  addMarkerListener: (marker, action, callback) ->
    google.maps.event.addListener marker, action, callback

$ ->
  window.Yumster.GoogleMaker = new GoogleMaker
  window.Yumster._GoogleMaker = GoogleMaker
