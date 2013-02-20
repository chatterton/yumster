window.Yumster or= {}

class Locations

  constructor: (@geocoder = new google.maps.Geocoder()) ->

  loadAddress: (map, address) ->
    unless address
      return
    @geocoder.geocode { 'address', address }, @loadAddressCallback

  loadAddressCallback: (results, status) ->
    console.log results
    console.log status

$ ->
  unless typeof google is "undefined"
    window.Yumster.Locations = new Locations
  window.Yumster._Locations = Locations
