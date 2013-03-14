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
