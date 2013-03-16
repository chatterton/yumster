window.Yumster or= {}
window.Yumster.MarkerSprite or= {}
window.Yumster.GoogleMaker or= {}
window.Yumster.Locations or= {}
window.Yumster.LocationManager or= {}
window.Yumster.Locations.Near or= {}
window.Yumster.Locations.Map or= {}

class LocationsMap

  constructor: () ->
    @gm = window.Yumster.GoogleMaker
    @markersOnMap = []

  setMap: (map) ->
    window.Yumster.Locations.Map.map = map

  fitMapToBounds: (lat, lng, span) ->
    bounds = @gm.makeLatLngBounds()
    ne = @gm.makeLatLng lat + span / 2, lng + span / 2
    bounds.extend ne
    sw = @gm.makeLatLng lat - span / 2, lng - span / 2
    bounds.extend sw
    window.Yumster.Locations.Map.map.fitBounds(bounds)

  putMarkerOnMap: (lat, lng, icon) ->
    marker = @gm.makeMarker {
      position: @gm.makeLatLng(lat, lng)
      map: window.Yumster.Locations.Map.map
      icon: icon
    }
    @markersOnMap.push marker
    marker

  getBoundsFromMap: () ->
    unless window.Yumster.Locations.Map.map
      return [null, null, null]
    bounds = window.Yumster.Locations.Map.map.getBounds()
    unless bounds
      return [null, null, null]
    center = window.Yumster.Locations.Map.map.getCenter()
    return [center.lat(), center.lng(), bounds.toSpan().lat()]

  zoomInAndRecenter: (lat, lng) ->
    window.Yumster.Locations.Map.map.setZoom(window.Yumster.Locations.Map.map.getZoom() + 1)
    window.Yumster.Locations.Map.map.setCenter @gm.makeLatLng(lat, lng)

  clear: () ->
    while marker = @markersOnMap.pop()
      marker.setMap(null)

  recenterWithGeoMarker: (button, geoMarker) ->
    window.Yumster.Locations.Map.map.controls[@gm.getControlPosition().TOP_RIGHT].push button


$ ->
  window.Yumster.Locations.Map = new LocationsMap
  window.Yumster.Locations._Map = LocationsMap
