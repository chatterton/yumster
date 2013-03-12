#= require jquery.history.js

window.Yumster or= {}
window.Yumster.Locations or= {}
window.Yumster.MapMarkers or= {}
window.Yumster.MarkerSprite or= {}
window.Yumster.Locations.Near or= {}

class LocationsNear

  constructor: (@templates = window.JST) ->
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @markersOnMap = []
    @allMarkers = []
    @fitMapToSearchResults = true
    @defaultSpan = .025

  setMap: (map) ->
    window.Yumster.Locations.Near.map = map

  createLocationHTML: (location) ->
    $(@templates['templates/nearby_location_item'](location))

  showMarkersAndClusters: (markers, clusters) ->
    container = $('#nearby_results')
    for marker, i in markers when i < 20
      location = marker.location
      location.letter = @alphabet[i]
      loc = @createLocationHTML(location)
      loc.appendTo(container)
      marker.setIcon(window.Yumster.MarkerSprite.makeMarkerImage(i))
      marker.setMap(window.Yumster.Locations.Near.map)
      @markersOnMap.push marker
    for cluster in clusters
      cluster.setMap(window.Yumster.Locations.Near.map)
      @markersOnMap.push cluster

  fillNearbyLocationsSuccess: (data) ->
    @emptyCurrentResults()
    container = $('#nearby_results')
    for location, i in data
      marker = window.Yumster.MapMarkers.addMarker(location.latitude, location.longitude)
      marker.location = location
      @allMarkers.push marker
    $('#map_reload').addClass('disabled')
    if data.length == 0
      $(@templates['templates/no_locations_found'](null)).appendTo(container)
    else
      [markers, clusters] = window.Yumster.MapMarkers.renderMarkersAndClusters(window.Yumster.Locations.Near.map.getBounds())
      @showMarkersAndClusters(markers, clusters)
      if @fitMapToSearchResults
        @fitMapToMarkers(window.Yumster.Locations.Near.map, @markersOnMap)

  fillNearbyLocationsFailure: (status, error) ->
    if status is 500 and error is "Too many locations returned"
      $(@templates['templates/too_many_locations'](null)).appendTo($('#nearby_results'))

  fillNearbyLocations: (lat, long, span) ->
    path = $('#nearby_ajax_address').attr("href")
    path += @createURLParams(lat, long, span)
    $.ajax {
      type: "GET"
      url: path
      dataType: "json"
      success: (data, status, jqxhr) ->
        window.Yumster.Locations.Near.fillNearbyLocationsSuccess(data)
      error: (jqXHR, status, errorThrown) ->
        window.Yumster.Locations.Near.fillNearbyLocationsFailure(jqXHR.status, jqXHR.responseText)
    }

  createURLParams: (lat, long, span) ->
    url = ""
    url += "?latitude=#{lat.toFixed(6)}"
    url += "&longitude=#{long.toFixed(6)}"
    url += "&span=#{span.toFixed(6)}"
    url

  updateURLLatLong: (lat, long, span) ->
    state = @createURLParams(lat, long, span)
    window.History.replaceState {}, null, state

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

  boundsChanged: ->
    $('#map_reload').removeClass('disabled')

  searchHere: ->
    @fitMapToSearchResults = false
    @searchMap()

  emptyCurrentResults: () ->
    $('#nearby_results').empty()
    while marker = @markersOnMap.pop() ## clear all markers
      marker.setMap(null)
    window.Yumster.MapMarkers.clear()

  searchMap: ->
    @emptyCurrentResults()
    span = @defaultSpan
    if window.Yumster.Locations.Near.map.getBounds()
      span = window.Yumster.Locations.Near.map.getBounds().toSpan().lat()
    center = window.Yumster.Locations.Near.map.getCenter()
    @fillNearbyLocations(center.lat(), center.lng(), span)
    @updateURLLatLong(center.lat(), center.lng(), span)

  makeLatLngBounds: () ->
    new google.maps.LatLngBounds

  fitMapToMarkers: (map, markers) ->
    bounds = @makeLatLngBounds()
    bounds.extend(marker.getPosition()) for marker in markers
    map.fitBounds(bounds)

  mapCallback: (result) ->
    @fitMapToSearchResults = true
    loc = result.geometry.location
    window.Yumster.Locations.Near.map.setCenter(loc)
    window.Yumster.Locations.Near.searchMap()

$ ->
  window.Yumster.Locations.Near = new LocationsNear
  # make prototype available for testing
  window.Yumster.Locations._Near = LocationsNear
