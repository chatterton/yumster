window.Yumster or= {}
window.Yumster.Locations or= {}

class Locations

  constructor: (@geocoder = new google.maps.Geocoder()) ->
    window.Yumster.Locations.geolocationCallback = null

  loadAddress: (address, callback) ->
    unless address and callback
      return
    window.Yumster.Locations.geolocationCallback = callback
    @geocoder.geocode { 'address', address }, @loadAddressCallback

  loadAddressCallback: (results, status) ->
    unless status is "OK"
      console.log "Error, geocoder returned status ", status
      return
    unless results.length > 0
      console.log "Error, geocoder found no results"
      return
    lat = results[0].geometry.location.lat()
    lng = results[0].geometry.location.lng()
    window.Yumster.Locations.geolocationCallback(lat, lng)

  initializeAddressSearch: (inputId, buttonId, addressCallback) ->
    addressSearchClick = ->
      address = $(inputId).val()
      window.Yumster.Locations.loadAddress(address, addressCallback)
      $(inputId).val('')
    $(buttonId).click ->
      addressSearchClick()
    $(inputId).keydown (event) ->
      if event.which is 13
        event.preventDefault()
        addressSearchClick()

$ ->
  unless typeof google is "undefined"
    window.Yumster.Locations = new Locations
  window.Yumster._Locations = Locations
