window.Yumster or= {}

class Locations

  constructor: (@geocoder = new google.maps.Geocoder()) ->
    @mapCallback = null

  loadAddress: (address, callback) ->
    unless address and callback
      return
    @mapCallback = callback
    @geocoder.geocode { 'address', address }, @loadAddressCallback

  loadAddressCallback: (results, status) ->
    unless status is "OK"
      console.log "Error, Google geocoder returned status ", status
      return
    unless results.length > 0
      console.log "Error, Google geocoder found no results"
      return
    @mapCallback(results[0])

$ ->
  unless typeof google is "undefined"
    window.Yumster.Locations = new Locations
  window.Yumster._Locations = Locations
