window.Yumster or= {}
window.Yumster.Locations or= {}

class Locations

  constructor: (@geocoder = new google.maps.Geocoder()) ->
    window.Yumster.Locations.mapCallback = null

  loadAddress: (address, callback) ->
    unless address and callback
      return
    window.Yumster.Locations.mapCallback = callback
    @geocoder.geocode { 'address', address }, @loadAddressCallback

  loadAddressCallback: (results, status) ->
    unless status is "OK"
      console.log "Error, Google geocoder returned status ", status
      return
    unless results.length > 0
      console.log "Error, Google geocoder found no results"
      return
    window.Yumster.Locations.mapCallback(results[0])

  initializeAddressSearch: (inputId, buttonId, addressCallback) ->
    addressSearchClick = ->
      address = $(inputId).val()
      window.Yumster.Locations.loadAddress(address, addressCallback)
      $(inputId).val('')
    $(buttonId).click(addressSearchClick())
    $(inputId).keydown (event) ->
      if event.which is 13
        event.preventDefault()
        addressSearchClick()

$ ->
  unless typeof google is "undefined"
    window.Yumster.Locations = new Locations
  window.Yumster._Locations = Locations
