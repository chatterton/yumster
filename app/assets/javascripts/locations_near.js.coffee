#= require jquery.history.js

window.Yumster or= {}
window.Yumster.Locations or= {}

class LocationsNear

  constructor: ->
    @initial_center_found = false
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  createLocationHTML: (location) ->
    skeleton = $('#location_container .location').clone()
    skeleton.find('.location_link').text(location.description)
    skeleton.find('.location_link').attr('href', "/locations/#{location.id}")
    skeleton.find('.location_category').text(location.category)
    skeleton.find('.location_marker').attr('src', location.icon)
    skeleton

  # Markers generated with e.g.
  # http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=E|33EE33|000000
  addMarkerToMap: (location, map = Gmaps.map.map) ->
    latlng = new google.maps.LatLng location.latitude, location.longitude
    marker = new google.maps.Marker {
      position: latlng
      map: map
      icon: location.icon
    }

  fillNearbyLocationsSuccess: (data) ->
    container = $('#locations_container')
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

  mapIdle: (map) ->
    unless @initial_center_found
      latitude = if @urlParam("latitude") then parseFloat(@urlParam("latitude")) else null
      longitude = if @urlParam("longitude") then parseFloat(@urlParam("longitude")) else null
      unless latitude and longitude
        lctn = map.getCenter()
        latitude = lctn.lat()
        longitude = lctn.lng()
        window.Yumster.Locations.Near.updateURLLatLong(latitude, longitude)
      window.Yumster.Locations.Near.fillNearbyLocations(latitude, longitude)
      @initial_center_found = true

  getMapCenter: (success, failure) ->
    latitude = if @urlParam("latitude") then parseFloat(@urlParam("latitude")) else null
    longitude = if @urlParam("longitude") then parseFloat(@urlParam("longitude")) else null
    if latitude and longitude
      return success(latitude, longitude)
    @geolocate(success, failure)

  geolocate: ->
    return [1, 2]

  urlParam: (name, address = window.location.href) ->
    results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(address)
    if results then results[1] else null

$ ->
  window.Yumster.Locations.Near = new LocationsNear