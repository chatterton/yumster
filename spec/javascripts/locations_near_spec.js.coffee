#= require spec_helper
#= require locations_near
#= require google_maker

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
    window.Yumster.Locations.Map or= {}
    @gm = new window.Yumster._GoogleMaker
    @locations.gm = @gm
    window.Yumster.Locations.Map.putMarkerOnMap = sinon.stub()
    window.Yumster.MarkerSprite.makeMarkerIcon = sinon.stub().returns {}

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

  describe "showMarkers(markerLocations)", ->
    beforeEach ->
      sinon.stub(@locations, "createLocationHTML").returns($("<i>OK!</i>"))
      sinon.stub(@locations, "setClickLinkListener")
      @locations.showMarkers ["location1", "location2"]
    afterEach ->
      @locations.createLocationHTML.restore()
      @locations.setClickLinkListener.restore()
    it "creates a marker for each location", ->
      window.Yumster.Locations.Map.putMarkerOnMap.callCount.should.equal 2
    it "populates #nearby_results with locations", ->
      container = $('#nearby_results').html()
      container.should.have.string("OK!")
    it "puts a link listener on each marker", ->
      @locations.setClickLinkListener.callCount.should.equal 2

  describe "showClusters(clusterLocations)", ->
    beforeEach ->
      sinon.stub(@locations, "setClickZoomListener")
      window.Yumster._MarkerSprite or= {}
      window.Yumster._MarkerSprite.MARKER_CLUSTER_ORDINAL or= 999
      @locations.showClusters ["cluster1", "cluster2", "cluster3"]
    afterEach ->
      @locations.setClickZoomListener.restore()
    it "creates a marker for each location", ->
      window.Yumster.Locations.Map.putMarkerOnMap.callCount.should.equal 3
    it "puts a zoom listener on each marker", ->
      @locations.setClickZoomListener.callCount.should.equal 3

  describe "fillNearbyLocationsSuccess(data)", ->
    beforeEach ->
      sinon.stub(@locations, "showMarkers")
      sinon.stub(@locations, "showClusters")
      sinon.stub(@locations, "emptyCurrentResults")
      @marker = {}
      window.Yumster.LocationManager.addLocations = sinon.stub()
      window.Yumster.LocationManager.getClusterLocations = sinon.stub().returns ["clusters"]
      window.Yumster.LocationManager.getMarkerLocations = sinon.stub().returns ["markers"]
    afterEach ->
      @locations.showMarkers.restore()
      @locations.showClusters.restore()
      @locations.emptyCurrentResults.restore()
    it "clears any current markers", ->
      @locations.fillNearbyLocationsSuccess([])
      @locations.emptyCurrentResults.callCount.should.equal 1
    it "loads the location manager with the results", ->
      data = ["foo"]
      @locations.fillNearbyLocationsSuccess data, 1, 2, 3
      window.Yumster.LocationManager.addLocations.callCount.should.equal 1
      args = window.Yumster.LocationManager.addLocations.firstCall.args
      args[0].should.equal data
      args[1].should.equal 1
      args[2].should.equal 2
      args[3].should.equal 3
    context "when there are several locations", ->
      beforeEach ->
        loc1 =
          check: 1
        loc2 =
          check: 2
        @loc_array = [ loc1, loc2 ]
        @locations.fillNearbyLocationsSuccess(@loc_array)
      it "renders markers from manager", ->
        @locations.showMarkers.callCount.should.equal 1
        @locations.showMarkers.firstCall.args[0].should.deep.equal ["markers"]
      it "renders clusters from manager", ->
        @locations.showClusters.callCount.should.equal 1
        @locations.showClusters.firstCall.args[0].should.deep.equal ["clusters"]
      it "should disable the map_reload button", ->
        $('#map_reload').is('.disabled').should.be.true
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

  describe "updateURL(lat, long, span)", ->
    beforeEach ->
      sinon.stub window.History, "replaceState"
    afterEach ->
      window.History.replaceState.restore()
    it "updates the address bar with latitude, longitude, and span", ->
      @locations.updateURL(41.001, 42.002, 33)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.001")
      new_address.should.have.string("42.002")
      new_address.should.have.string("span=33")
    it "shortens long floats to six decimal places", ->
      @locations.updateURL(41.111111111111, 42.002, 1)
      new_address = window.History.replaceState.getCall(0).args[2]
      new_address.should.have.string("41.111111")
      new_address.should.not.have.string("41.1111111")

  describe "urlParam(name)", ->
    it "returns parameters from query string", ->
      address = "http://whatever?foo=ONE&bar=TWO"
      one = @locations.urlParam("foo", address)
      one.should.equal("ONE")
      two = @locations.urlParam("bar", address)
      two.should.equal("TWO")

  describe "urlParamToFloat(name)", ->
    beforeEach ->
      sinon.stub(@locations, "urlParam")
    afterEach ->
      @locations.urlParam.restore()
    context "when a parameter is a number", ->
      it "returns a number", ->
        @locations.urlParam.returns('1024')
        check = @locations.urlParamToFloat('whatever')
        check.should.be.a 'number'
        check.should.equal 1024
    context "when a parameter is NaN", ->
      it "returns null", ->
        @locations.urlParam.returns('biscuits')
        check = @locations.urlParamToFloat('whatever')
        assert.isNull(check)

  describe "boundsChanged()", ->
    it "enables the Search Here button", ->
      $('#map_reload').is('.disabled').should.be.true
      @locations.boundsChanged()
      $('#map_reload').is('.disabled').should.not.be.true

  describe "emptyCurrentResults()", ->
    beforeEach ->
      $('<li>whatever</li>').appendTo('#nearby_results')
      window.Yumster.LocationManager.clear = sinon.spy()
      window.Yumster.Locations.Map.clear = sinon.spy()
      @locations.emptyCurrentResults()
    it "should clear the current results list", ->
      $('#nearby_results').children().length.should.equal 0
    it "should clear the map", ->
      window.Yumster.Locations.Map.clear.callCount.should.equal 1
    it "clears the location manager", ->
      window.Yumster.LocationManager.clear.callCount.should.equal 1

  describe "geolocationCallback(result)", ->
      sinon.stub @locations, "searchHere"
      window.Yumster.Locations.Map.fitMapToBounds = sinon.spy()
      @locations.geolocationCallback 90210, 92102
      @args = window.Yumster.Locations.Map.fitMapToBounds.firstCall.args
    afterEach ->
      @locations.searchHere.restore()
    it "should move the map to the location", ->
      window.Yumster.Locations.Map.fitMapToBounds.callCount.should.equal 1
      @args[0].should.equal 90210
      @args[1].should.equal 92102
    it "fills in a default span", ->
      @args[2].should.be.at.least .001
    it "should reload the map in this new location", ->
      @locations.searchHere.callCount.should.equal 1

  describe "retrieving map parameters from the URL", ->
    beforeEach ->
      sinon.stub(@locations, "urlParam")
      @locations.urlParam.withArgs('lat').returns '10'
      @locations.urlParam.withArgs('lng').returns '11'
      @locations.urlParam.withArgs('span').returns '12'
    afterEach ->
      @locations.urlParam.restore()
    context "when the parameters are valid", ->
      it "returns an array containing them as floats", ->
        [lat, lng, span] = @locations.getMapParamsFromURL()
        lat.should.equal 10
        lng.should.equal 11
        span.should.equal 12
    context "when one of the parameters is bogus", ->
      it "returns null for that parameter", ->
        @locations.urlParam.withArgs('span').returns 'hamburgers'
        [lat, lng, span] = @locations.getMapParamsFromURL()
        lat.should.equal 10
        lng.should.equal 11
        assert.isNull(span)

  describe "upon page load", ->
    beforeEach ->
      sinon.stub(@locations, "getMapParamsFromURL").returns [10, 11, 12]
      window.Yumster.Locations.Map.fitMapToBounds = sinon.stub()
      sinon.stub(@locations, "fillNearbyLocations")
    afterEach ->
      @locations.getMapParamsFromURL.restore()
      @locations.fillNearbyLocations.restore()
    context "with complete map parameters on URL", ->
      beforeEach ->
        @locations.pageLoad()
      it "shows the map using the URL parameters", ->
        window.Yumster.Locations.Map.fitMapToBounds.callCount.should.equal 1
      it "loads and displays locations", ->
        @locations.fillNearbyLocations.callCount.should.equal 1
    context "without complete map parameters", ->
      beforeEach ->
        @locations.getMapParamsFromURL.returns [null, 11, 12]
        @locations.pageLoad()
      it "does nothing", ->
        window.Yumster.Locations.Map.fitMapToBounds.callCount.should.equal 0
        @locations.fillNearbyLocations.callCount.should.equal 0

  describe "user hits the 'search here' button", ->
    beforeEach ->
      sinon.stub(@locations, "fillNearbyLocations")
      window.Yumster.Locations.Map.getBoundsFromMap = sinon.stub().returns [31, 32, 33]
      sinon.stub(@locations, "updateURL")
      @locations.searchHere()
    afterEach ->
      @locations.fillNearbyLocations.restore()
      @locations.updateURL.restore()
    it "updates the URL from the map", ->
      @locations.updateURL.callCount.should.equal 1
      @locations.updateURL.firstCall.args[0].should.equal 31
      @locations.updateURL.firstCall.args[1].should.equal 32
      @locations.updateURL.firstCall.args[2].should.equal 33
    it "loads and displays locations", ->
      @locations.fillNearbyLocations.callCount.should.equal 1
    context "when the bounds are no good", ->
      beforeEach ->
        @locations.fillNearbyLocations.reset()
        @locations.updateURL.reset()
        window.Yumster.Locations.Map.getBoundsFromMap = sinon.stub().returns [31, 32, null]
        @locations.searchHere()
      it "does nothing", ->
        @locations.updateURL.callCount.should.equal 0
        @locations.fillNearbyLocations.callCount.should.equal 0
