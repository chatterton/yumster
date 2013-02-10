#= require jquery.validate.min

window.Yumster or= {}
window.Yumster.Locations or= {}

LocationsNew = class LocationsNew

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

  current_location: (lat, long) ->
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)

$ ->
  window.Yumster.Locations.New = new LocationsNew
