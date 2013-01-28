window.Yumster or= {}

Locations = class Locations

  constructor: ->

  current_location: (lat, long) =>
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

$ ->
  window.Yumster.Locations = new Locations
