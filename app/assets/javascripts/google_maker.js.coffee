window.Yumster or= {}
window.Yumster.GoogleMaker or= {}

class GoogleMaker

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude

  makeMarker: (config) ->
    new google.maps.Marker config

  makeLatLngBounds: () ->
    new google.maps.LatLngBounds

  addEventListener: (object, action, callback) ->
    google.maps.event.addListener object, action, callback

  addDOMListener: (object, action, callback) ->
    google.maps.event.addDomListener object, action, callback

  getControlPosition: () ->
    return google.maps.ControlPosition

$ ->
  window.Yumster.GoogleMaker = new GoogleMaker
  window.Yumster._GoogleMaker = GoogleMaker
