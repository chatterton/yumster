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
