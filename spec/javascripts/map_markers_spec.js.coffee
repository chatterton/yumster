#= require spec_helper
#= require map_markers

describe "window.Yumster.MapMarkers", ->
  beforeEach ->
    @MapMarkers = window.Yumster._MapMarkers
    @mapmarkers = new @MapMarkers
    window.Yumster.MapMarkers = @mapmarkers
    @map = sinon.spy()

  describe "placeMarkerOnMap(ordinal, map, lat, lng)", ->
    beforeEach ->
      sinon.stub(@mapmarkers, "makeLatLng")
      @marker = {}
      sinon.stub(@mapmarkers, "makeMarker").returns @marker
      sinon.stub(@mapmarkers, "makeMarkerImage").returns "image"
      @checkmarker = @mapmarkers.placeMarkerOnMap(0, @map, 14, 15)
    afterEach ->
      @mapmarkers.makeLatLng.restore()
      @mapmarkers.makeMarker.restore()
    it "adds a marker to the map", ->
      @mapmarkers.makeMarker.callCount.should.equal 1
      config = @mapmarkers.makeMarker.firstCall.args[0]
      config["map"].should.equal @map
      config["icon"].should.equal "image"
    it "returns the marker", ->
      @checkmarker.should.equal @marker

  describe "spriteOffsetsForOrdinal(ordinal)", ->
    it "returns 0, 0 for 0", ->
      [xoffset, yoffset] = @mapmarkers.spriteOffsetsForOrdinal(0)
      xoffset.should.equal 0
      yoffset.should.equal 0
    it "correctly wraps around to the next column", ->
      [xoffset, yoffset] = @mapmarkers.spriteOffsetsForOrdinal(@MapMarkers.SPRITE_XCOUNT)
      xoffset.should.equal @MapMarkers.SPRITE_XSIZE
      yoffset.should.equal 0

  describe "addMarker(marker)", ->
    it "push the marker onto the array", ->
      @mapmarkers.markers = []
      @mapmarkers.addMarker("fuh")
      @mapmarkers.markers[0].should.equal "fuh"

  describe "clear()", ->
    it "empties marker array", ->
      @mapmarkers.markers = ["thing"]
      @mapmarkers.clear()
      @mapmarkers.markers.should.be.empty

  describe "renderMarkersAndClusters(map)", ->
    beforeEach ->
      bounds =
        contains: (marker) -> true
      @map.getBounds = () -> bounds
      [@mk, @cl] = @mapmarkers.renderMarkersAndClusters(@map)
    it "returns a marker and cluster array", ->
      @mk.should.be.an('array')
      @cl.should.be.an('array')

