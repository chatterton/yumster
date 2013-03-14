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
      it "calls the map callback with the first result", ->
        @locations.loadAddressCallback(["first", "second"], "OK")
        @callback.callCount.should.equal 1
        @callback.firstCall.args[0].should.equal "first"

  describe "geolocate(success, failure)", ->
    beforeEach ->
      @keepFunction = navigator.geolocation.getCurrentPosition
      @success = sinon.spy()
      @failure = sinon.spy()
    afterEach ->
      navigator.geolocation.getCurrentPosition = @keepFunction
    context "when the user allows geolocation", ->
      beforeEach ->
        navigator.geolocation.getCurrentPosition = (f1, f2) ->
          f1({
            coords:
              latitude: 5
              longitude: 6
          })
      it "calls success on coordinates", ->
        @locations.geolocate(@success, @failure)
        @success.callCount.should.equal 1
        @failure.callCount.should.equal 0
    context "when the user does not allow geolocation", ->
      beforeEach ->
        navigator.geolocation.getCurrentPosition = (f1, f2) ->
          f2({})
      it "calls failure callback", ->
        @locations.geolocate(@success, @failure)
        @success.callCount.should.equal 0
        @failure.callCount.should.equal 1

