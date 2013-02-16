#= require jquery.history.js

window.Yumster or= {}
window.Yumster.Locations or= {}

class LocationsNear

  constructor: (@templates = window.JST) ->
    @initial_center_found = false
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  setMap: (map) ->
    @map = map

  createLocationHTML: (location) ->
    $(@templates['templates/nearby_location_item'](location))

  # Markers generated with e.g.
  # http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=E|96c941|000000
  addMarkerToMap: (location) ->
    latlng = new google.maps.LatLng location.latitude, location.longitude
    marker = new google.maps.Marker {
      position: latlng
      map: @map
      icon: location.icon
    }

  fillNearbyLocationsSuccess: (data) ->
    container = $('#nearby_results')
    for location, i in data when i < 20
      location.icon = "/assets/markers/#{@alphabet[i]}.png"
      loc = @createLocationHTML(location)
      loc.appendTo(container)
      @addMarkerToMap(location)

  fillNearbyLocations: (lat, long) ->
    path = $('#nearby_ajax_address').attr("href")
    path = "#{path}?latitude=#{lat}&longitude=#{long}"
    $.ajax {
      type: "GET"
      url: path
      dataType: "json"
      success: (data, status, jqxhr) ->
        window.Yumster.Locations.Near.fillNearbyLocationsSuccess(data)
      error: (data) ->
        console.log(data)
    }

  updateURLLatLong: (lat, long) ->
    window.History.replaceState {}, null, "?latitude=#{lat.toFixed(6)}&longitude=#{long.toFixed(6)}"

  getMapCenter: (success, failure) ->
    latitude = if @urlParam("latitude") then parseFloat(@urlParam("latitude")) else null
    longitude = if @urlParam("longitude") then parseFloat(@urlParam("longitude")) else null
    if latitude and longitude
      return success(latitude, longitude, true)
    @geolocate(success, failure)

  geolocate: (success, failure) ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        success(position.coords.latitude, position.coords.longitude, false)
      , ->
        return failure("User did not allow geolocation")
    else
      return failure("Browser does not support geolocation")

  urlParam: (name, address = window.location.href) ->
    results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(address)
    if results then results[1] else null

  centerChanged: ->
    $('#map_reload').removeClass('disabled')

$ ->
  window.Yumster.Locations.Near = new LocationsNear
  # make prototype available for testing
  window.Yumster.Locations._Near = LocationsNear
