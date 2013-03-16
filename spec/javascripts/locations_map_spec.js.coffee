#= require spec_helper
#= require locations_map

describe "window.Yumster.Locations.Map", ->
  beforeEach ->
    @lm = new window.Yumster.Locations._Map
    window.Yumster.Locations.Map = @lm
    @map = {}
    window.Yumster.Locations.Map.map = @map
    @lm.gm =
      makeLatLngBounds: () ->
        extend: () ->
      makeLatLng: () ->

  describe "setting the map", ->
    it "saves the map to a window global", ->
      @lm.setMap("foo")
      window.Yumster.Locations.Map.map.should.equal "foo"

  describe "fit map to lat, lng, and span", ->
    beforeEach ->
      @map.fitBounds = sinon.spy()
      @lm.fitMapToBounds 13, 14, 0.15
    it "calls fitBounds on the map", ->
      @map.fitBounds.callCount.should.equal 1

  describe "add a marker to the map", ->
    beforeEach ->
      @lm.gm.makeMarker = sinon.stub().returns("mmmarker")
      @check = @lm.putMarkerOnMap 1, 2, {}
    it "makes the marker", ->
      @lm.gm.makeMarker.callCount.should.equal 1
    it "adds the marker to the on-map array", ->
      @lm.markersOnMap.should.contain "mmmarker"
    it "returns the marker", ->
      @check.should.equal "mmmarker"

  describe "get the map's current boundaries", ->
    beforeEach ->
      window.Yumster.Locations.Map.map =
        getBounds: () ->
          toSpan: () ->
            lat: () -> .42
        getCenter: () ->
          lat: () -> 22
          lng: () -> 33
    it "returns lat, lng, and span from the map", ->
      [lat, lng, span] = @lm.getBoundsFromMap()
      lat.should.equal 22
      lng.should.equal 33
      span.should.equal .42
    context "when the map is null", ->
      it "returns nulls", ->
        window.Yumster.Locations.Map.map = null
        [lat, lng, span] = @lm.getBoundsFromMap()
        assert.isNull(lat or lng or span)
    context "when the map boundary is null", ->
      it "returns nulls", ->
        window.Yumster.Locations.Map.map =
          getBounds: () -> null
        [lat, lng, span] = @lm.getBoundsFromMap()
        assert.isNull(lat or lng or span)

  describe "zoom in and recenter", ->
    beforeEach ->
      window.Yumster.Locations.Map.map.getZoom = () -> 321
      window.Yumster.Locations.Map.map.setZoom = sinon.spy()
      window.Yumster.Locations.Map.map.setCenter = sinon.spy()
      @lm.gm.makeLatLng = sinon.stub().returns("yep")
      @lm.zoomInAndRecenter 16, 17
    it "sets the map zoom +1", ->
      window.Yumster.Locations.Map.map.setZoom.firstCall.args[0].should.equal 322
    it "recenters the map", ->
      window.Yumster.Locations.Map.map.setCenter.firstCall.args[0].should.equal "yep"

  describe "clearing the map", ->
    beforeEach ->
      @m1 = { setMap: sinon.spy() }
      @m2 = { setMap: sinon.spy() }
      @lm.markersOnMap = [@m1, @m2]
      @lm.clear()
    it "detatches all markers from map", ->
      assert.isNull(@m1.setMap.firstCall.args[0])
      assert.isNull(@m2.setMap.firstCall.args[0])
    it "empties the markers array", ->
      @lm.markersOnMap.should.be.empty

  describe "adding a recenter widget to the map", ->
    beforeEach ->
      @map.controls = []
      @lm.gm.getControlPosition = () ->
        TOP_RIGHT: 123
      @lm.gm.addDOMListener = () ->
      @map.controls[123] =
        push: sinon.spy()
      @lm.recenterWithGeoMarker({}, {})
    it "places the widget in the upper right-hand corner", ->
      @map.controls[123].push.callCount.should.equal 1
