#= require spec_helper
#= require map_markers

describe "window.Yumster.MapMarkers", ->
  beforeEach ->
    @MapMarkers = window.Yumster._MapMarkers
    @mapmarkers = new @MapMarkers
    window.Yumster.MapMarkers = @mapmarkers
    @map = sinon.spy()

  describe "addMarker(lat, lng)", ->
    beforeEach ->
      sinon.stub(@mapmarkers, "makeLatLng")
      @marker = {}
      sinon.stub(@mapmarkers, "makeMarker").returns @marker
      window.Yumster.MarkerSprite.makeMarkerImage = sinon.stub().returns "image"
      @mapmarkers.markers = []
      @checkmarker = @mapmarkers.addMarker(14, 15)
    afterEach ->
      @mapmarkers.makeLatLng.restore()
      @mapmarkers.makeMarker.restore()
    it "returns the marker", ->
      @checkmarker.should.equal @marker
    it "pushes the marker onto the array", ->
      @mapmarkers.markers[0].should.equal @marker

  describe "clear()", ->
    it "empties marker array", ->
      @mapmarkers.markers = ["thing"]
      @mapmarkers.clear()
      @mapmarkers.markers.should.be.empty

  describe "renderMarkersAndClusters(map)", ->
    beforeEach ->
      bounds =
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
      [@mk, @cl] = @mapmarkers.renderMarkersAndClusters(bounds)
    afterEach ->
      @mapmarkers.makeMarker.restore()
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
