#= require jquery.validate.min

window.Yumster or= {}
window.Yumster.Locations or= {}

Locations = class Locations

  constructor: ->
    @setup_validator()

  setup_validator: ->
    $('#new_location').validate
      rules:
        "location[latitude]": { required: true }
        "location[longitude]": { required: true }
        "location[category]": { required: true }
        "location[description]":
          required: true
          minlength: 5
      ignore: "" # validator defaults to ignoring hidden
    $('#new_location :input').change ->
      window.Yumster.Locations.New.validate()

  current_location: (lat, long) ->
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

  validate: ->
    if $('#new_location').valid()
      $('input#location_submit').attr('disabled', false)
    else
      $('input#location_submit').attr('disabled', true)

$ ->
  window.Yumster.Locations.New = new Locations
