window.Yumster or= {}
window.Yumster.MarkerSprite or= {}
window.Yumster.Locations or= {}
window.Yumster.LocationManager or= {}
window.Yumster.Locations.Near or= {}
window.Yumster.Locations.Map or= {}

class LocationsMap

  setMap: (map) ->
    window.Yumster.Locations.Map.map = map

$ ->
  window.Yumster.Locations.Map = new LocationsMap
  window.Yumster.Locations._Map = LocationsMap
