#= require spec_helper
#= require map_markers

describe "window.Yumster.MapMarkers", ->
  beforeEach ->
    @MapMarkers = window.Yumster._MapMarkers
    @mapmarkers = new @MapMarkers
    window.Yumster.MapMarkers = @mapmarkers

  describe "createMarker(ordinal, map, lat, lng)", ->
    beforeEach ->
      sinon.stub(@mapmarkers, "makeLatLng")
      @marker = {}
      sinon.stub(@mapmarkers, "makeMarker").returns @marker
      sinon.stub(@mapmarkers, "makeMarkerImage").returns "image"
      @map = sinon.spy()
      @checkmarker = @mapmarkers.createMarker(0, @map, 14, 15)
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
