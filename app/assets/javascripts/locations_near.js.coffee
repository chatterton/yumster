#= require jquery.history.js

window.Yumster or= {}
window.Yumster.Locations or= {}

class LocationsNear

  constructor: ->

  createLocationHTML: (location) ->
    skeleton = $('#location_container .location').clone()
    skeleton.find('.location_link').text(location.description)
    skeleton.find('.location_link').attr('href', "/locations/#{location.id}")
    skeleton.find('.location_category').text(location.category)
    skeleton

  fillNearbyLocationsSuccess: (data) ->
    container = $('#locations_container')
    for location in data
      loc = window.Yumster.Locations.Near.createLocationHTML(location)
      loc.appendTo(container)

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

  updateAddressPosition: (lat, long) ->
    console.log(window.History)
    window.History.replaceState {}, null, "?latitude=#{lat.toFixed(6)}&longitude=#{long.toFixed(6)}"

$ ->
  window.Yumster.Locations.Near = new LocationsNear
