#= require jquery.validate.min

window.Yumster or= {}

Locations = class Locations

  constructor: ->

  current_location: (lat, long) =>
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

  validate: ->
    $('input#location_submit').attr('disabled', false)

$ ->
  window.Yumster.Locations = new Locations
