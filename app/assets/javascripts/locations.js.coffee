#= require jquery.validate.min

window.Yumster or= {}

Locations = class Locations

  constructor: ->

  current_location: (lat, long) =>
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

  validate: ->
    $('#new_location').validate
      rules:
        location_latitude: { required: true }
        location_longitude: { required: true }
        location_category: { required: true }
        location_description:
          required: true
          minlength: 5
      ignore: ""
    $("#new_location").removeAttr("novalidate");
    if $('#new_location').valid()
      $('input#location_submit').attr('disabled', false)
    else
      $('input#location_submit').attr('disabled', true)

$ ->
  window.Yumster.Locations = new Locations
