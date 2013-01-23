window.Yumster or= {}

window.Yumster.Locations = class Locations

  @current_location = (lat, long) ->
    $('input#location_latitude').val(lat)
    $('input#location_longitude').val(long)
