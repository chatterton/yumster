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
    it "pushes the marker onto the array", ->
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
      @map.getBounds = () ->
        toSpan: () ->
          lat: () -> .25
        contains: (marker) -> true
      @m1 =
        getPosition: () ->
          lat: () -> 42.0001
          lng: () -> 42.0002
      @m2 =
        getPosition: () ->
          lat: () -> 42.0003
          lng: () -> 42.0004
      @m3 =
        getPosition: () ->
          lat: () -> 45.0001
          lng: () -> 45.0002
      @m4 =
        getPosition: () ->
          lat: () -> 50.0001
          lng: () -> 50.0002
      @mapmarkers.markers = [@m1, @m2, @m3, @m4]
      sinon.stub(@mapmarkers, "makeMarker").returns "clusteredmarker"
      sinon.stub(@mapmarkers, "makeMarkerImage")
      [@mk, @cl] = @mapmarkers.renderMarkersAndClusters(@map)
    afterEach ->
      @mapmarkers.makeMarker.restore()
      @mapmarkers.makeMarkerImage.restore()
    it "returns a marker and cluster array", ->
      @mk.should.be.an('array')
      @cl.should.be.an('array')
    it "does not cluster distant markers", ->
      @mk.length.should.equal 2
      @mk.should.contain @m3
      @mk.should.contain @m4
    it "clusters nearby markers", ->
      @cl.length.should.equal 1
      @cl[0].should.equal "clusteredmarker"
