#= require spec_helper
#= require locations_near
#= require jquery.history.js

describe "window.Yumster.Locations.Near", ->

  beforeEach ->
    @templates = {}
    @locations = new window.Yumster.Locations._Near(@templates)
    window.Yumster.Locations.Near = @locations
    $('body').append('''
      <a href="/whatever" id="nearby_ajax_address" />
      <a class="btn disabled" id="map_reload" href="#">button</a>
      <ul id="nearby_results">
      </ul>
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
      sinon.stub(@locations, "fitMapToMarkers")
      @locations.createLocationHTML.withArgs(loc1).returns($("<li>OK1</li>"))
      @locations.createLocationHTML.withArgs(loc2).returns($("<li>OK2</li>"))
      @locations.fillNearbyLocationsSuccess(locations)
    afterEach ->
      @locations.createLocationHTML.restore()
      @locations.addMarkerToMap.restore()
      @locations.fitMapToMarkers.restore()
    it "populates #nearby_results with locations", ->
      container = $('#nearby_results').html()
      container.should.have.string("OK1")
      container.should.have.string("OK2")
    it "creates markers A and B", ->
      @locations.addMarkerToMap.firstCall.args[0].icon.should.include 'A.png'
      @locations.addMarkerToMap.secondCall.args[0].icon.should.include 'B.png'
    it "should fit the map to the new marker set", ->
      @locations.fitMapToMarkers.callCount.should.equal 1
    it "should disable the map_reload button", ->
      $('#map_reload').is('.disabled').should.be.true
    context "when there are more than 20 locations", ->
      beforeEach ->
        locations = ("location #{i}" for i in [1..25])
        @locations.createLocationHTML.reset()
        @locations.createLocationHTML.returns($("<div />"))
        @locations.fillNearbyLocationsSuccess(locations)
      it "only shows the first 20", ->
        @locations.createLocationHTML.callCount.should.equal 20
    context "when there are zero locations", ->
      beforeEach ->
        $('#nearby_results').empty()
        locations = []
        @templates['templates/no_locations_found'] = ->
          '<li>no loc found template</li>'
        @locations.fillNearbyLocationsSuccess(locations)
      it "shows a friendly error message", ->
        container = $('#nearby_results').html()
        container.should.have.string("no loc found template")

  describe "createLocationHTML(location)", ->
    beforeEach ->
      @templates['templates/nearby_location_item'] = sinon.stub().returns("<div></div>")
      @html = @locations.createLocationHTML(location)
    it "returns a jquery html object", ->
      @html.should.be.an.instanceof jQuery

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

  describe "centerChanged()", ->
    it "enables the Search Here button", ->
      $('#map_reload').is('.disabled').should.be.true
      @locations.centerChanged()
      $('#map_reload').is('.disabled').should.not.be.true

  describe "searchHere()", ->
    beforeEach ->
      @map =
        getCenter: () ->
      @locations.setMap @map
      sinon.spy(@locations, "fillNearbyLocations")
      sinon.spy(@locations, "updateURLLatLong")
      sinon.stub(@map, "getCenter").returns {
        lat: () -> 666
        lng: () -> 667
      }
      $('#map_reload').removeClass('disabled')
      $('<li>whatever</li>').appendTo('#nearby_results')
      @locations.searchHere()
    afterEach ->
      @locations.fillNearbyLocations.restore()
      @locations.updateURLLatLong.restore()
      @map.getCenter.restore()
    it "should clear the current results list", ->
      $('#nearby_results').children().length.should.equal 0
    it "should search for nearby locations", ->
      @locations.fillNearbyLocations.callCount.should.equal 1
      @locations.fillNearbyLocations.firstCall.args[0].should.equal 666
      @locations.fillNearbyLocations.firstCall.args[1].should.equal 667
    it "should update the URL with the current center", ->
      @locations.updateURLLatLong.callCount.should.equal 1
      @locations.updateURLLatLong.firstCall.args[0].should.equal 666
      @locations.updateURLLatLong.firstCall.args[1].should.equal 667

  describe "fitMapToMarkers(map, markers)", ->
    beforeEach ->
      @map =
        fitBounds: sinon.spy()
      @bounds =
        extend: sinon.spy()
      m1 =
        getPosition: () -> "marker1"
      m2 =
        getPosition: () -> "marker2"
      sinon.stub(@locations, 'makeLatLngBounds').returns(@bounds)
      @locations.fitMapToMarkers(@map, [m1, m2])
    afterEach ->
      @locations.makeLatLngBounds.restore()
    it 'fits map bounds to collection of marker positions', ->
      @bounds.extend.callCount.should.equal 2
      @bounds.extend.firstCall.args[0].should.equal "marker1"
      @bounds.extend.secondCall.args[0].should.equal "marker2"
      @map.fitBounds.callCount.should.equal 1

  describe "mapCallback(result)", ->
    beforeEach ->
      @location = {}
      result =
        geometry:
          location: @location
      @map =
        setCenter: sinon.spy()
      @locations.setMap @map
      @locations.searchHere = sinon.spy()
      @locations.mapCallback(result)
    it "should move the map to the location", ->
      @map.setCenter.callCount.should.equal 1
      @map.setCenter.firstCall.args[0].should.equal @location
    it "should reload the map in this new location", ->
      @locations.searchHere.callCount.should.equal 1
