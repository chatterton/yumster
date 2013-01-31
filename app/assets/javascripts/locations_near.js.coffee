window.Yumster or= {}
window.Yumster.Locations or= {}

class LocationsNear

  constructor: ->

  fillNearbyLocationsSuccess: (data) ->

  fillNearbyLocations: (lat, long) ->
    path = $('#nearby_ajax_address').attr("href")
    $.ajax {
      type: "GET"
      url: path
      accepts: "application/json"
      success: (data, status, jqxhr) ->
        window.Yumster.Locations.Near.fillNearbyLocationsSuccess(data)
    }

$ ->
  window.Yumster.Locations.Near = new LocationsNear
