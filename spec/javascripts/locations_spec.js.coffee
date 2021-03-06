#= require spec_helper
#= require locations

describe "window.Yumster.Locations", ->

  beforeEach ->
    @geocoder = {}
    @geocoder.geocode = sinon.spy()
    @locations = new window.Yumster._Locations(@geocoder)
    window.Yumster.Locations = @locations

  describe "loadAddress(address, callback)", ->
    context "when the address is blank", ->
      it "does nothing", ->
        @locations.loadAddress({}, "")
        @geocoder.geocode.callCount.should.equal 0
    context "when there's an address", ->
      it "calls out to google to get a position for that address", ->
        @locations.loadAddress("this is an address", {})
        @geocoder.geocode.callCount.should.equal 1
        @geocoder.geocode.firstCall.args[0].address.should.equal "this is an address"
      it "holds on to a copy of the callback", ->
        @locations.loadAddress("this is an address", "callbacco")
        @locations.geolocationCallback.should.equal "callbacco"

  describe "loadAddressCallback(results, status)", ->
    beforeEach ->
      sinon.spy(console, "log")
      @callback = sinon.spy()
      @locations.geolocationCallback = @callback
    afterEach ->
      console.log.restore()
    context "when the status is not OK", ->
      it "logs an error and does nothing", ->
        @locations.loadAddressCallback([], "NOT OK")
        console.log.callCount.should.equal 1
        console.log.firstCall.args.should.contain "NOT OK"
        @callback.callCount.should.equal 0
    context "with status OK and no results", ->
      it "logs an error and does nothing", ->
        @locations.loadAddressCallback([], "OK")
        console.log.callCount.should.equal 1
        @callback.callCount.should.equal 0
    context "with status OK and a few results", ->
      beforeEach ->
        first =
          geometry:
            location:
              lat: () -> 1
              lng: () -> 2
        second =
          geometry:
            location:
              lat: () -> 3
              lng: () -> 4
        @locations.loadAddressCallback([first, second], "OK")
      it "calls the map callback with the first result", ->
        @callback.callCount.should.equal 1
        @callback.firstCall.args[0].should.equal 1
        @callback.firstCall.args[1].should.equal 2

