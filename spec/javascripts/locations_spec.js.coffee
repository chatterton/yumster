#= require spec_helper
#= require locations

describe "Locations#current_location", ->

  before ->
    @Locations = window.Yumster.Locations

  it "updates the form with given latitude and longitude", ->
    $('body').append('<input id="location_latitude" type="text" />')
    $('body').append('<input id="location_longitude" type="text" />')

    @Locations.current_location(0.01, 2.03)

    $('body').find('#location_latitude').val().should.equal '0.01'
    $('body').find('#location_longitude').val().should.equal '2.03'
