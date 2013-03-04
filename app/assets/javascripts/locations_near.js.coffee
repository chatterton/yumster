#= require jquery.history.js

window.Yumster or= {}
window.Yumster.Locations or= {}
window.Yumster.Locations.Near or= {}

class LocationsNear

  constructor: (@templates = window.JST) ->
    @initial_center_found = false
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @markers = []

  setMap: (map) ->
    window.Yumster.Locations.Near.map = map

  createLocationHTML: (location) ->
    $(@templates['templates/nearby_location_item'](location))

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude
  makeMarker: (config) ->
    new google.maps.Marker config
  # Markers generated with e.g.
  # http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=E|96c941|000000
  addMarkerToMap: (location) ->
    latlng = @makeLatLng( location.latitude, location.longitude )
    marker = @makeMarker {
      position: latlng
      map: window.Yumster.Locations.Near.map
      icon: location.icon
    }
    @markers.push marker

  fillNearbyLocationsSuccess: (data) ->
    container = $('#nearby_results')
    for location, i in data when i < 20
      location.icon = "/assets/markers/#{@alphabet[i]}.png"
      loc = @createLocationHTML(location)
      loc.appendTo(container)
      @addMarkerToMap(location)
    $('#map_reload').addClass('disabled')
    if data.length == 0
      $(@templates['templates/no_locations_found'](null)).appendTo(container)
    else
      @fitMapToMarkers(window.Yumster.Locations.Near.map, @markers)

  fillNearbyLocationsFailure: (status, error) ->
    console.log status
    console.log error

  fillNearbyLocations: (lat, long) ->
    path = $('#nearby_ajax_address').attr("href")
    path = "#{path}?latitude=#{lat}&longitude=#{long}"
    $.ajax {
      type: "GET"
      url: path
      dataType: "json"
      success: (data, status, jqxhr) ->
        window.Yumster.Locations.Near.fillNearbyLocationsSuccess(data)
      error: (jqXHR, status, errorThrown) ->
        window.Yumster.Locations.Near.fillNearbyLocationsFailure(status, errorThrown)
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

  searchHere: ->
    center = window.Yumster.Locations.Near.map.getCenter()
    $('#nearby_results').empty()
    while marker = @markers.pop() ## clear all markers
      marker.setMap(null)
    @fillNearbyLocations(center.lat(), center.lng())
    @updateURLLatLong(center.lat(), center.lng())

  makeLatLngBounds: () ->
    new google.maps.LatLngBounds

  fitMapToMarkers: (map, markers) ->
    bounds = @makeLatLngBounds()
    bounds.extend(marker.getPosition()) for marker in markers
    map.fitBounds(bounds)

  mapCallback: (result) ->
    loc = result.geometry.location
    window.Yumster.Locations.Near.map.setCenter(loc)
    window.Yumster.Locations.Near.searchHere()

$ ->
  window.Yumster.Locations.Near = new LocationsNear
  # make prototype available for testing
  window.Yumster.Locations._Near = LocationsNear
