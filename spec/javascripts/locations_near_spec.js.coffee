#= require spec_helper
#= require locations_near
#= require jquery.history.js

describe "window.Yumster.Locations.Near", ->

  beforeEach ->
    @templates =
      'templates/nearby_location_item': () ->
      'templates/no_locations_found': () ->
      'templates/too_many_locations': () ->
    @locations = new window.Yumster.Locations._Near(@templates)
    window.Yumster.Locations.Near = @locations
    $('body').append('''
      <a href="/whatever" id="nearby_ajax_address" />
      <a class="btn disabled" id="map_reload" href="#">button</a>
      <ul id="nearby_results">
      </ul>
    ''')

  describe "fillNearbyLocations(lat, long, span)", ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      sinon.stub(@locations, "fillNearbyLocationsSuccess")
      sinon.stub(@locations, "fillNearbyLocationsFailure")
      sinon.stub(@locations, "createURLParams").returns("?yolo")
    afterEach ->
      @server.restore()
      @locations.fillNearbyLocationsSuccess.restore()
      @locations.fillNearbyLocationsFailure.restore()
      @locations.createURLParams.restore()
    context "get locations from server", ->
      beforeEach ->
        @server.respondWith "GET", null, [200, { "Content-Type": "application/json" }, '["whatevah"]']
        @locations.fillNearbyLocations(50, 51, 3)
        @server.respond()
      it "fires an xhr to the server", ->
        @server.requests.length.should.equal 1
      it "builds the address correctly", ->
        @server.requests[0].url.should.equal "/whatever?yolo"
      it "calls into the success method with data", ->
        sinon.assert.calledOnce(@locations.fillNearbyLocationsSuccess)
        @locations.fillNearbyLocationsSuccess.calledWith(["whatevah"]).should.be.ok
    context "on server error", ->
      beforeEach ->
        @server.respondWith "GET", null, [500, {}, 'BAM']
        @locations.fillNearbyLocations(50, 51)
        @server.respond()
      it "calls into the failure method", ->
        @locations.fillNearbyLocationsFailure.callCount.should.equal 1
        @locations.fillNearbyLocationsFailure.calledWith(500, "BAM").should.be.ok

  describe "fillNearbyLocationsSuccess(data)", ->
    beforeEach ->
      sinon.stub(@locations, "createLocationHTML")
      sinon.stub(@locations, "fitMapToMarkers")
      @marker = {}
      window.Yumster.MapMarkers.addMarker = sinon.stub().returns(@marker)
    afterEach ->
      @locations.createLocationHTML.restore()
      @locations.fitMapToMarkers.restore()
    context "when there are several locations", ->
      beforeEach ->
        loc1 =
          check: 1
        loc2 =
          check: 2
        @loc_array = [ loc1, loc2 ]
        @locations.createLocationHTML.withArgs(loc1).returns($("<li>OK1</li>"))
        @locations.createLocationHTML.withArgs(loc2).returns($("<li>OK2</li>"))
        @locations.fitMapToSearchResults = false
        @locations.fillNearbyLocationsSuccess(@loc_array)
      it "populates #nearby_results with locations", ->
        container = $('#nearby_results').html()
        container.should.have.string("OK1")
        container.should.have.string("OK2")
      context "when fitMapToSearchResults is false", ->
        it "should not fit the map to the new marker set", ->
          @locations.fitMapToMarkers.callCount.should.equal 0
      context "when fitMapToSearchResults is true", ->
        beforeEach ->
          @locations.fitMapToSearchResults = true
          @locations.fillNearbyLocationsSuccess(@loc_array)
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
      it "does not try to fit map to marker set", ->
        @locations.fitMapToMarkers.callCount.should.equal 0

  describe "fillNearbyLocationsFailure(status, error)", ->
    beforeEach ->
      @container = $('#nearby_results')
      @container.empty()
    context "on some random error", ->
      beforeEach ->
        @locations.fillNearbyLocationsFailure(501, "yogurt")
      it "does nothing", ->
        container = @container.html()
        container.should.equal ""
    context "on too many locations error", ->
      beforeEach ->
        @templates['templates/too_many_locations'] = ->
          '<li>toomany</li>'
        @locations.fillNearbyLocationsFailure(500, "Too many locations returned")
      it "shows the too many results template", ->
        container = @container.html()
        container.should.have.string "toomany"

  describe "createLocationHTML(location)", ->
    beforeEach ->
      @templates['templates/nearby_location_item'] = sinon.stub().returns("<div></div>")
      @html = @locations.createLocationHTML(location)
    it "returns a jquery html object", ->
      @html.should.be.an.instanceof jQuery

  describe "updateURLLatLong(lat, long, span)", ->
    beforeEach ->
      sinon.stub window.History, "replaceState"
    afterEach ->
      window.History.replaceState.restore()
    it "updates the address bar with latitude, longitude, and span", ->
      @locations.updateURLLatLong(41.001, 42.002, 33)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.001")
      new_address.should.have.string("42.002")
      new_address.should.have.string("span=33")
    it "shortens long floats to six decimal places", ->
      @locations.updateURLLatLong(41.111111111111, 42.002, 1)
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

  describe "boundsChanged()", ->
    it "enables the Search Here button", ->
      $('#map_reload').is('.disabled').should.be.true
      @locations.boundsChanged()
      $('#map_reload').is('.disabled').should.not.be.true

  describe "searchHere()", ->
    beforeEach ->
      sinon.stub(@locations, "searchMap")
      @locations.searchHere()
    afterEach ->
      @locations.searchMap.restore()
    it "sets fitMapToSearchResults to false", ->
      @locations.searchMap.callCount.should.equal 1
    it "searches the current map", ->
      @locations.fitMapToSearchResults.should.equal false

  describe "emptyCurrentResults()", ->
    beforeEach ->
      $('<li>whatever</li>').appendTo('#nearby_results')
      @locations.markers.push {
        setMap: () ->
      }
      @locations.emptyCurrentResults()
    it "should clear the current results list", ->
      $('#nearby_results').children().length.should.equal 0
    it "should empty the markers array", ->
      @locations.markers.should.be.empty

  describe "searchMap()", ->
    beforeEach ->
      @map = {}
      @map =
        getCenter: () ->
          lat: () -> 666
          lng: () -> 667
        getBounds: () ->
          toSpan: () ->
            lat: () -> 2
            lng: () -> 3
      @locations.setMap @map
      $('#map_reload').removeClass('disabled')
      sinon.stub(@locations, "fillNearbyLocations")
      sinon.stub(@locations, "updateURLLatLong")
      sinon.stub(@locations, "emptyCurrentResults")
      @locations.searchMap()
    afterEach ->
      @locations.fillNearbyLocations.restore()
      @locations.updateURLLatLong.restore()
      @locations.emptyCurrentResults.restore()
    it "should clear any current results", ->
      @locations.emptyCurrentResults.callCount.should.equal 1
    it "should search for nearby locations", ->
      @locations.fillNearbyLocations.callCount.should.equal 1
      @locations.fillNearbyLocations.firstCall.args[0].should.equal 666
      @locations.fillNearbyLocations.firstCall.args[1].should.equal 667
      @locations.fillNearbyLocations.firstCall.args[2].should.equal 2
    it "should update the URL", ->
      @locations.updateURLLatLong.callCount.should.equal 1
      @locations.updateURLLatLong.firstCall.args[0].should.equal 666
      @locations.updateURLLatLong.firstCall.args[1].should.equal 667
      @locations.updateURLLatLong.firstCall.args[2].should.equal 2
    context "when getBounds returns undefined", ->
      beforeEach ->
        @map.getBounds = () ->
          undefined
        @locations.searchMap()
      it "fills in span with a reasonable default", ->
        @locations.updateURLLatLong.secondCall.args[2].should.equal window.Yumster.Locations.Near.defaultSpan


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
      @locations.searchMap = sinon.spy()
      @locations.fitMapToSearchResults = false
      @locations.mapCallback(result)
    it "should move the map to the location", ->
      @map.setCenter.callCount.should.equal 1
      @map.setCenter.firstCall.args[0].should.equal @location
    it "should reload the map in this new location", ->
      @locations.searchMap.callCount.should.equal 1
    it "should set fitMapToSearchResults true", ->
      @locations.fitMapToSearchResults.should.equal true
