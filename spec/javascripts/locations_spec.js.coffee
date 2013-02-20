#= require spec_helper
#= require locations

describe "window.Yumster.Locations", ->

  beforeEach ->
    @geocoder = {}
    @geocoder.geocode = sinon.spy()
    @locations = new window.Yumster._Locations(@geocoder)
    window.Yumster.Locations = @locations

  describe "loadAddress(map, address)", ->
    context "when the address is blank", ->
      it "does nothing", ->
        @locations.loadAddress({}, "")
        @geocoder.geocode.callCount.should.equal 0
    context "when there's an address", ->
      it "calls out to google to get a position for that address", ->
        @locations.loadAddress({}, "this is an address")
        @geocoder.geocode.callCount.should.equal 1
        @geocoder.geocode.firstCall.args[0].address.should.equal "this is an address"
