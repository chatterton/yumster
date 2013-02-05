#= require spec_helper
#= require locations_near
#= require jquery.history.js

describe "window.Yumster.Locations.Near", ->

  beforeEach ->
    @locations = window.Yumster.Locations.Near
    $('body').append('''
      <a href="/whatever" id="nearby_ajax_address" />
      <div id="locations_container"></div>
      <div id="location_container">
        <div class="location well">
          <div><img class="location_marker" /></div>
          <div>
            <a class="location_link" /><br>
            Category: <span class="location_category"></span>
          </div>
          <br>
        </div>
      </div>
    ''')

  describe "fillNearbyLocations(lat, long)", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith "GET", null, [200, { "Content-Type": "application/json" }, '["whatevah"]']
      sinon.spy(@locations, "fillNearbyLocationsSuccess")
    afterEach ->
      @server.restore()
      @locations.fillNearbyLocationsSuccess.restore()
    context "get locations from server", ->
      beforeEach ->
        @locations.fillNearbyLocations(50, 51)
        @server.respond()
      it "fires an xhr to the server", ->
        @server.requests.length.should.equal 1
      it "builds the address correctly", ->
        @server.requests[0].url.should.equal "/whatever?latitude=50&longitude=51"
      it "calls into the success method with data", ->
        sinon.assert.calledOnce(@locations.fillNearbyLocationsSuccess)
        @locations.fillNearbyLocationsSuccess.calledWith(["whatevah"]).should.be.ok

  describe "fillNearbyLocationsSuccess(data)", ->
    beforeEach ->
      loc1 =
        check: 1
      loc2 =
        check: 2
      locations = [ loc1, loc2 ]
      sinon.stub(@locations, "createLocationHTML")
      sinon.stub(@locations, "addMarkerToMap")
      @locations.createLocationHTML.withArgs(loc1).returns($("<div>OK1</div>"))
      @locations.createLocationHTML.withArgs(loc2).returns($("<div>OK2</div>"))
      @locations.fillNearbyLocationsSuccess(locations)
    afterEach ->
      @locations.createLocationHTML.restore()
      @locations.addMarkerToMap.restore()
    it "populates #locations_container with locations", ->
      container = $('#locations_container').html()
      container.should.have.string("OK1")
      container.should.have.string("OK2")
    it "creates markers A and B", ->
      @locations.addMarkerToMap.firstCall.args[0].icon.should.include 'A.png'
      @locations.addMarkerToMap.secondCall.args[0].icon.should.include 'B.png'
    context "when there are more than 20 locations", ->
      beforeEach ->
        locations = ("location #{i}" for i in [1..25])
        @locations.createLocationHTML.reset()
        @locations.createLocationHTML.returns($("<div />"))
        @locations.fillNearbyLocationsSuccess(locations)
      it "only shows the first 20", ->
        @locations.createLocationHTML.callCount.should.equal 20


  describe "createLocationHTML(location)", ->
    beforeEach ->
      location =
        "category": "Organization"
        "description": "The Church is an Organization"
        "id": 7
        "latitude": 47.6187787290335
        "longitude": -122.302739496959
        "icon": "/assets/foo.png"
      @html = @locations.createLocationHTML(location, "Q").html()
    it "populates an element with the name and link", ->
      @html.should.have.string("The Church")
      @html.should.have.string("/locations/7")
    it "shows the marker image", ->
      @html.should.have.string("/assets/foo.png")

  describe "updateURLLatLong(lat, long)", ->
    beforeEach ->
      sinon.stub window.History, "replaceState"
    afterEach ->
      window.History.replaceState.restore()
    it "updates the address bar with latitude and longitude", ->
      @locations.updateURLLatLong(41.001, 42.002)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.001")
      new_address.should.have.string("42.002")
    it "shortens long floats to six decimal places", ->
      @locations.updateURLLatLong(41.111111111111, 42.002)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.111111")
      new_address.should.not.have.string("41.1111111")

  describe "mapIdle(map)", ->
    beforeEach ->
      sinon.spy(window.Yumster.Locations.Near, "updateURLLatLong")
      sinon.spy(window.Yumster.Locations.Near, "fillNearbyLocations")
      sinon.stub(@locations, "urlParam")
      @map =
        getCenter: ->
          return {
            lat: -> 105
            lng: -> 106
          }
      @locations.initial_center_found = false
    afterEach ->
      window.Yumster.Locations.Near.updateURLLatLong.restore()
      window.Yumster.Locations.Near.fillNearbyLocations.restore()
      @locations.urlParam.restore()
    context "when coordinates are provided on the query string", ->
      beforeEach ->
        @locations.urlParam.withArgs("latitude").returns("999")
        @locations.urlParam.withArgs("longitude").returns("998")
        @locations.mapIdle(@map)
      it "calls fill with those params", ->
        @locations.fillNearbyLocations.getCall(0).args[0].should.equal 999
        @locations.fillNearbyLocations.getCall(0).args[1].should.equal 998
      it "does not call updateurl", ->
        window.Yumster.Locations.Near.updateURLLatLong.callCount.should.equal 0
    context "when there are no coordinates provided on the query string", ->
      beforeEach ->
        @locations.urlParam.withArgs("latitude").returns(null)
        @locations.urlParam.withArgs("longitude").returns(null)
        @locations.mapIdle(@map)
      it "calls fill with map center lat/long", ->
        @locations.fillNearbyLocations.getCall(0).args[0].should.equal 105
        @locations.fillNearbyLocations.getCall(0).args[1].should.equal 106
      it "calls updateurl with map center lat/long", ->
        @locations.updateURLLatLong.getCall(0).args[0].should.equal 105
        @locations.updateURLLatLong.getCall(0).args[1].should.equal 106
    context "when called a second time", ->
      it "only calls fill once", ->
        @locations.mapIdle(@map)
        @locations.mapIdle(@map)
        @locations.fillNearbyLocations.callCount.should.equal 1

  describe "getMapCenter(success, failure)", ->
    beforeEach ->
      sinon.stub(@locations, "urlParam")
      sinon.stub(@locations, "geolocate")
      @success = sinon.spy()
      @failure = sinon.spy()
    afterEach ->
      @locations.urlParam.restore()
      @locations.geolocate.restore()
    context "when coordinates are provided on the query string", ->
      beforeEach ->
        @locations.urlParam.withArgs("latitude").returns("15")
        @locations.urlParam.withArgs("longitude").returns("16")
      it "calls the success callback on them", ->
        @locations.getMapCenter(@success, @failure)
        @success.firstCall.args[0].should.equal 15
        @success.firstCall.args[1].should.equal 16
    context "when there are no coordinates", ->
      beforeEach ->
        @locations.urlParam.withArgs("latitude").returns(null)
        @locations.urlParam.withArgs("longitude").returns(null)
      it "calls geolocate with the callbacks", ->
        @locations.getMapCenter(@success, @failure)
        @locations.geolocate.callCount.should.equal 1
        @locations.geolocate.firstCall.args[0].should.equal @success
        @locations.geolocate.firstCall.args[1].should.equal @failure

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

  describe "urlParam(name)", ->
    it "returns parameters from query string", ->
      address = "http://whatever?foo=ONE&bar=TWO"
      one = @locations.urlParam("foo", address)
      one.should.equal("ONE")
      two = @locations.urlParam("bar", address)
      two.should.equal("TWO")
