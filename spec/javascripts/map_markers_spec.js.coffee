#= require spec_helper
#= require map_markers

describe "window.Yumster.MapMarkers", ->
  beforeEach ->
    @mapmarkers = new window.Yumster._MapMarkers
    window.Yumster.MapMarkers = @mapmarkers

  describe "createMarker(ordinal, map, lat, lng)", ->
    beforeEach ->
      sinon.stub(@mapmarkers, "makeLatLng")
      @marker = {}
      sinon.stub(@mapmarkers, "makeMarker").returns(@marker)
      @map = sinon.spy()
      @checkmarker = @mapmarkers.createMarker(0, @map, 14, 15)
    afterEach ->
      @mapmarkers.makeLatLng.restore()
      @mapmarkers.makeMarker.restore()
    it "adds a marker to the map", ->
      @mapmarkers.makeMarker.callCount.should.equal 1
      config = @mapmarkers.makeMarker.firstCall.args[0]
      config["map"].should.equal @map
    it "returns the marker", ->
      @checkmarker.should.equal @marker
