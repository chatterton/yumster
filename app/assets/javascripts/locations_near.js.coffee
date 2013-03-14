#= require jquery.history.js

window.Yumster or= {}
window.Yumster.MarkerSprite or= {}
window.Yumster.Locations or= {}
window.Yumster.LocationManager or= {}
window.Yumster.Locations.Near or= {}

class LocationsNear

  constructor: (@templates = window.JST) ->
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @markersOnMap = []
    @fitMapToSearchResults = true
    @defaultSpan = .025

  createLocationHTML: (location) ->
    $(@templates['templates/nearby_location_item'](location))

  makeLatLng: (latitude, longitude) ->
    new google.maps.LatLng latitude, longitude
  makeMarker: (config) ->
    new google.maps.Marker config
  makeClickLinkListener: (marker, link) ->
    google.maps.event.addListener marker, 'click', ->
      window.location.href = link
  makeClickZoomListener: (marker) ->
    google.maps.event.addListener marker, 'click', ->
      window.Yumster.Locations.Near.map.setZoom(window.Yumster.Locations.Near.map.getZoom() + 1)
      window.Yumster.Locations.Near.map.setCenter marker.getPosition()
      window.Yumster.Locations.Near.searchHere()
  putMarkerOnMap: (lat, lng, ord) ->
    marker = @makeMarker {
      position: @makeLatLng(lat, lng)
      map: window.Yumster.Locations.Near.map
      icon: window.Yumster.MarkerSprite.makeMarkerIcon(ord)
    }
    @markersOnMap.push marker
    marker

  showMarkers: (markerLocations) ->
    container = $('#nearby_results')
    for location, i in markerLocations when i < @alphabet.length
      marker = @putMarkerOnMap(location.latitude, location.longitude, i)
      @makeClickLinkListener(marker, '/locations/'+location.id)
      location.letter = @alphabet[i]
      loc = @createLocationHTML(location)
      loc.appendTo(container)

  showClusters: (clusterLocations) ->
    for cluster in clusterLocations
      marker = @putMarkerOnMap(cluster.latitude, cluster.longitude, window.Yumster._MarkerSprite.MARKER_CLUSTER_ORDINAL)
      @makeClickZoomListener(marker)

  fillNearbyLocationsSuccess: (data, lat, long, span) ->
    @emptyCurrentResults()
    window.Yumster.LocationManager.addLocations(data, lat, long, span)
    container = $('#nearby_results')
    $('#map_reload').addClass('disabled')
    if data.length == 0
      $(@templates['templates/no_locations_found'](null)).appendTo(container)
    else
      markers = window.Yumster.LocationManager.getMarkerLocations(lat, long, span)
      @showMarkers(markers)
      clusters = window.Yumster.LocationManager.getClusterLocations(lat, long, span)
      @showClusters(clusters)
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
        window.Yumster.Locations.Near.fillNearbyLocationsSuccess(data, lat, long, span)
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
  urlParamToFloat: (name) ->
    val = @urlParam(name)
    if val
      if parseFloat(val)
        return parseFloat(val)
    return null

  boundsChanged: ->
    $('#map_reload').removeClass('disabled')

  searchHere: ->
    @fitMapToSearchResults = false
    @searchMap()

  emptyCurrentResults: () ->
    $('#nearby_results').empty()
    while marker = @markersOnMap.pop() ## clear all markers
      marker.setMap(null)
    window.Yumster.LocationManager.clear()

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

  getMapParamsFromURL: () ->
    lat = @urlParamToFloat('lat')
    lng = @urlParamToFloat('lng')
    span = @urlParamToFloat('span')
    return [lat, lng, span]

  pageLoad: () ->
    [lat, lng, span] = @getMapParamsFromURL()
    if lat and lng and span
      window.Yumster.Locations.Map.fitMapToBounds lat, lng, span
      @searchHere()

$ ->
  window.Yumster.Locations.Near = new LocationsNear
  window.Yumster.Locations._Near = LocationsNear
