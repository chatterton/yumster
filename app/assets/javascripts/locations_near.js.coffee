#= require jquery.history.js

window.Yumster or= {}
window.Yumster.MarkerSprite or= {}
window.Yumster.Locations or= {}
window.Yumster.LocationManager or= {}
window.Yumster.Locations.Near or= {}

class LocationsNear
  @DEFAULT_SPAN: .018

  ## Use slightly smaller bounds in the URL than the map returns, to make
  ## map scaling more predictable
  @BOUNDS_FACTOR: .75

  constructor: (@templates = window.JST) ->
    @alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @gm = window.Yumster.GoogleMaker

  createLocationHTML: (location) ->
    $(@templates['templates/nearby_location_item'](location))

  setClickLinkListener: (marker, link) ->
    @gm.addEventListener marker, 'click', ->
      window.location.href = link

  setClickZoomListener: (marker, lat, lng) ->
    @gm.addEventListener marker, 'click', ->
      window.Yumster.Locations.Map.zoomInAndRecenter lat, lng
      window.Yumster.Locations.Near.searchHere()

  showMarkers: (markerLocations) ->
    container = $('#nearby_results')
    for location, i in markerLocations when i < @alphabet.length
      icon = window.Yumster.MarkerSprite.makeMarkerIcon(i)
      marker = window.Yumster.Locations.Map.putMarkerOnMap(location.latitude, location.longitude, icon)
      @setClickLinkListener(marker, '/locations/'+location.id)
      location.letter = @alphabet[i]
      loc = @createLocationHTML(location)
      loc.appendTo(container)

  showClusters: (clusterLocations) ->
    for cluster in clusterLocations
      icon = window.Yumster.MarkerSprite.makeMarkerIcon(window.Yumster._MarkerSprite.MARKER_CLUSTER)
      marker = window.Yumster.Locations.Map.putMarkerOnMap(cluster.latitude, cluster.longitude, icon)
      @setClickZoomListener(marker, cluster.latitude, cluster.longitude)

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

  createURLParams: (lat, lng, span) ->
    url = ""
    url += "?lat=#{lat.toFixed(6)}"
    url += "&lng=#{lng.toFixed(6)}"
    url += "&span=#{span.toFixed(6)}"
    url

  updateURL: (lat, lng, span) ->
    state = @createURLParams(lat, lng, span)
    window.History.replaceState {}, null, state

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

  emptyCurrentResults: () ->
    $('#nearby_results').empty()
    window.Yumster.Locations.Map.clear()
    window.Yumster.LocationManager.clear()

  geolocationCallback: (lat, lng) ->
    window.Yumster.Locations.Map.fitMapToBounds lat, lng, LocationsNear.DEFAULT_SPAN
    window.Yumster.Locations.Near.searchHere()

  getMapParamsFromURL: () ->
    lat = @urlParamToFloat('lat')
    lng = @urlParamToFloat('lng')
    span = @urlParamToFloat('span')
    return [lat, lng, span]

  pageLoad: () ->
    [lat, lng, span] = @getMapParamsFromURL()
    if lat and lng and span
      window.Yumster.Locations.Map.fitMapToBounds lat, lng, span * LocationsNear.BOUNDS_FACTOR
      @fillNearbyLocations lat, lng, span

  searchHere: ->
    [lat, lng, span] = window.Yumster.Locations.Map.getBoundsFromMap()
    unless lat and lng and span
      return
    @updateURL lat, lng, span
    @fillNearbyLocations lat, lng, span

  geolocationFailure: (code) ->
    container = $('#nearby_results')
    $(@templates['templates/cannot_determine_location'](null)).appendTo(container)

$ ->
  window.Yumster.Locations.Near = new LocationsNear
  window.Yumster.Locations._Near = LocationsNear
